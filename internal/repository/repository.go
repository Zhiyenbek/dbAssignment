package repository

import (
	"context"
	"errors"
	"fmt"
	"log"
	"time"

	"github.com/Zhiyenbek/dbAssignment/internal/models"
	"github.com/jackc/pgtype"
	"github.com/jackc/pgx/v4"
	"github.com/jackc/pgx/v4/pgxpool"
	"go.uber.org/zap"
)

type repository struct {
	db      *pgxpool.Pool
	timeout time.Duration
	log     *zap.SugaredLogger
}

type Repository interface {
	GetTypes() ([]*models.GetDiseaseTypesResponse, error)
	GetDiseases(types int64) ([]*models.GetDiseasesResponse, error)
	AddDisease(*models.AddDiseaseRequest) error
}

func NewRepository(db *pgxpool.Pool, log *zap.SugaredLogger) Repository {
	return &repository{
		db:      db,
		timeout: time.Second * 5,
		log:     log,
	}
}

func (r *repository) GetTypes() ([]*models.GetDiseaseTypesResponse, error) {
	timeout := r.timeout
	ctx, cancel := context.WithTimeout(context.Background(), timeout)
	defer cancel()
	query := `SELECT id, description FROM DiseaseType`
	rows, err := r.db.Query(ctx, query)
	if err != nil {
		r.log.Errorf("err while getting types %v", err)
		return nil, err
	}
	defer rows.Close()
	var responses []*models.GetDiseaseTypesResponse
	for rows.Next() {
		response := &models.GetDiseaseTypesResponse{}
		if err = rows.Scan(&response.ID, &response.Description); err != nil {
			r.log.Errorf("Error occurred while parsing DB data to models: %s", err.Error())
			return nil, err
		}
		responses = append(responses, response)
	}
	if err = rows.Err(); err != nil {
		r.log.Errorf("Error occurred : %s", err.Error())
		return nil, err
	}
	return responses, err
}

func (r *repository) GetDiseases(types int64) ([]*models.GetDiseasesResponse, error) {
	timeout := r.timeout
	ctx, cancel := context.WithTimeout(context.Background(), timeout)
	defer cancel()
	query := `SELECT 
					Disease.disease_code, Disease.pathogen, Disease.description, Discover.cname, Discover.first_enc_date 
				FROM
					Disease INNER JOIN Discover ON Disease.disease_code = Discover.disease_code WHERE Disease.id = $1`
	rows, err := r.db.Query(ctx, query, types)
	if err != nil {
		r.log.Errorf("err while getting types %v", err)
		return nil, err
	}
	defer rows.Close()
	var responses []*models.GetDiseasesResponse
	for rows.Next() {
		var dt pgtype.Date
		response := &models.GetDiseasesResponse{}
		if err = rows.Scan(&response.DiseaseCode, &response.Pathogen, &response.Description, &response.Cname, &dt); err != nil {
			r.log.Errorf("Error occurred while parsing DB data to models: %s", err.Error())
			return nil, err
		}
		response.FirstIncDate = dt.Time
		responses = append(responses, response)
	}
	if err = rows.Err(); err != nil {
		r.log.Errorf("Error occurred : %s", err.Error())
		return nil, err
	}
	return responses, err
}
func (r *repository) AddDisease(req *models.AddDiseaseRequest) error {
	timeout := r.timeout
	var population int
	var id int64
	ctx, cancel := context.WithTimeout(context.Background(), timeout)
	defer cancel()

	query := `SELECT population FROM Country WHERE cname=$1`

	err := r.db.QueryRow(ctx, query, req.Cname).Scan(&population)
	if err != nil {
		r.log.Errorf("error occured %v", err)
		if errors.Is(err, pgx.ErrNoRows) {
			return models.ErrCountryNotFound
		}
		return err
	}

	query = `SELECT id FROM Disease WHERE disease_code=$1`
	err = r.db.QueryRow(ctx, query, req.DiseaseCode).Scan(&id)
	if err == nil {
		r.log.Errorf("disease exists")
		return models.ErrDiseaseExists
	}
	if err != nil {
		if !errors.Is(err, pgx.ErrNoRows) {
			r.log.Errorf("error occured while adding disease: %v", err)
			return err
		}
		r.log.Errorf("error occured while adding disease: %v", err)
		return err
	}

	tx, err := r.db.BeginTx(ctx, pgx.TxOptions{
		DeferrableMode: pgx.NotDeferrable,
	})
	if err != nil {
		r.log.Errorf("could not init tx %v", err)
		return err
	}

	query = `INSERT INTO
				Disease (disease_code, pathogen, description, id)
 			  VALUES
				($1,$2,$3,$4) RETURNING disease_code;`
	err = r.db.QueryRow(ctx, query, req.DiseaseCode, req.Pathogen, req.Description, req.ID).Scan(&req.DiseaseCode)
	if err != nil {
		tx.Rollback(ctx)
		r.log.Errorf("Error occured while adding disease %v", err)
		return err
	}

	layout := "2006-01-02"
	incDate, _ := time.Parse(layout, req.FirstIncDate)

	query = `INSERT INTO
				discover (cname, disease_code, first_enc_date)
  			VALUES
				($1, $2, $3)`

	_, err = r.db.Exec(ctx, query, req.Cname, req.DiseaseCode, incDate)
	if err != nil {
		tx.Rollback(ctx)
		r.log.Errorf("Error occured while adding discover: %v", err)
		return err
	}
	err = tx.Commit(ctx)
	if err != nil {
		errTX := tx.Rollback(ctx)
		if errTX != nil {
			log.Printf("ERROR: transaction error: %s", errTX)
		}
		return fmt.Errorf("error occurred while adding new disease: %v", err)
	}
	return nil
}
