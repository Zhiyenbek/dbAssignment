package models

import "time"

type GetDiseasesResponse struct {
	DiseaseCode  string    `json:"disease_code"`
	Pathogen     string    `json:"pathogen"`
	Description  string    `json:"description"`
	Cname        string    `json:"country_name"`
	FirstIncDate time.Time `json:"first_inc_date"`
}
type AddDiseaseRequest struct {
	DiseaseCode  string `json:"disease_code" binding:"required"`
	Pathogen     string `json:"pathogen" binding:"required"`
	Description  string `json:"description" binding:"required"`
	Cname        string `json:"country_name" binding:"required"`
	FirstIncDate string `json:"first_inc_date" binding:"required"`
	ID           int64  `json:"-"`
}
type GetDiseaseTypesResponse struct {
	Description string `json:"description"`
	ID          int64  `json:"id"`
}
