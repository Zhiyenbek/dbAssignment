package handler

import (
	"github.com/Zhiyenbek/dbAssignment/internal/repository"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

type handler struct {
	// repo   *repository.repository
	logger *zap.SugaredLogger
	repo   repository.Repository
}
type Handler interface {
	InitRoutes() *gin.Engine
}

func NewHandler(logger *zap.SugaredLogger, repo repository.Repository) Handler {
	return &handler{
		logger: logger,
		repo:   repo,
	}
}

// InitRoutes() - method of handler that initializes all the routes. Function returns gin.Engine
func (h *handler) InitRoutes() *gin.Engine {
	router := gin.Default()
	router.Use(cors.Default())
	dRouter := router.Group("/diseases")
	{
		dRouter.GET("/types", h.GetTypes)
		dRouter.GET("/:type_id", h.GetDiseases)
		dRouter.POST("/:type_id", h.AddDisease)
		dRouter.DELETE("/:disease_code", h.DeleteDisease)
		dRouter.PUT("/:disease_code", h.UpdateDisease)
	}

	return router
}
