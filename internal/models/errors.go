package models

import "errors"

var (
	ErrPatientNotFound = errors.New("PATIENT_NOT_FOUND")
	ErrInvalidInput    = errors.New("INVALID_INPUT")
	ErrCountryNotFound = errors.New("COUNTRY_NOT_FOUND")
	ErrInternalServer  = errors.New("INTERNAL_SERVER_ERROR")
	ErrDiseaseExists   = errors.New("DISEASE_ALREADY_EXISTS")
)
