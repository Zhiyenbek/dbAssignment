package handler

import (
	"errors"
	"log"
	"strconv"

	"github.com/Zhiyenbek/dbAssignment/internal/models"
	"github.com/gin-gonic/gin"
	"github.com/gin-gonic/gin/binding"
)

func (h *handler) GetDiseases(c *gin.Context) {
	typeID := c.Param("type_id")
	id, err := strconv.Atoi(typeID)
	if err != nil || id < 1 {
		h.logger.Error("ERROR: invalid input, missing user id")
		c.AbortWithStatusJSON(400, sendResponse(-1, nil, models.ErrInvalidInput))
		return
	}
	pageNum, err := strconv.Atoi(c.Query("page_num"))
	if err != nil || pageNum < 1 {
		pageNum = 1
	}
	pageSize, err := strconv.Atoi(c.Query("page_size"))
	if err != nil || pageSize < 1 {
		pageSize = 10
	}
	res, err := h.repo.GetDiseases(int64(id))
	if err != nil {
		c.AbortWithStatusJSON(400, sendResponse(-1, nil, models.ErrInternalServer))
		return
	}
	c.JSON(200, sendResponse(0, res, nil))
}

func (h *handler) AddDisease(c *gin.Context) {
	typeID := c.Param("type_id")
	id, err := strconv.Atoi(typeID)
	if err != nil || id < 1 {
		h.logger.Error("ERROR: invalid input, missing user id")
		c.AbortWithStatusJSON(400, sendResponse(-1, nil, models.ErrInvalidInput))
		return
	}
	req := &models.AddDiseaseRequest{}
	if err := c.ShouldBindWith(req, binding.JSON); err != nil {
		log.Printf("ERROR: invalid input, some fields are incorrect: %s\n", err.Error())
		c.AbortWithStatusJSON(400, sendResponse(-1, nil, models.ErrInvalidInput))
		return
	}
	req.ID = int64(id)
	err = h.repo.AddDisease(req)
	if err != nil {
		switch {
		case errors.Is(err, models.ErrCountryNotFound):
			h.logger.Errorf(err.Error())
			c.AbortWithStatusJSON(404, sendResponse(-1, nil, models.ErrCountryNotFound))
			return
		case errors.Is(err, models.ErrDiseaseExists):
			c.AbortWithStatusJSON(400, sendResponse(-1, nil, models.ErrDiseaseExists))
			return
		}
		c.AbortWithStatusJSON(500, sendResponse(-1, nil, models.ErrInternalServer))
		return
	}
	c.JSON(200, sendResponse(0, nil, nil))
}

func (h *handler) GetTypes(c *gin.Context) {
	res, err := h.repo.GetTypes()
	if err != nil {
		c.AbortWithStatusJSON(400, sendResponse(-1, nil, models.ErrInternalServer))
		return
	}
	c.JSON(200, sendResponse(0, res, nil))
}
func (h *handler) DeleteDisease(c *gin.Context) {
	dCode := c.Param("disease_code")
	if dCode == "" {
		c.AbortWithStatusJSON(400, sendResponse(-1, nil, models.ErrInvalidInput))
		return
	}
	err := h.repo.DeleteDisease(dCode)
	if err != nil {
		c.AbortWithStatusJSON(400, sendResponse(-1, nil, models.ErrInternalServer))
		return
	}
	c.JSON(200, sendResponse(0, 0, nil))
}

func (h *handler) UpdateDisease(c *gin.Context) {

}

func sendResponse(status int, data interface{}, err error) gin.H {
	var errResponse gin.H
	if err != nil {
		errResponse = gin.H{
			"message": err.Error(),
		}
	} else {
		errResponse = nil
	}

	return gin.H{
		"data":   data,
		"status": status,
		"error":  errResponse,
	}
}
