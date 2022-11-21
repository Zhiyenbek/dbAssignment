package app

import (
	"context"
	"log"
	"net/http"
	"os"
	"os/signal"
	"strconv"
	"syscall"

	"github.com/Zhiyenbek/dbAssignment/config"
	"github.com/Zhiyenbek/dbAssignment/internal/connection"
	"github.com/Zhiyenbek/dbAssignment/internal/handler"
	"github.com/Zhiyenbek/dbAssignment/internal/repository"
	"go.uber.org/zap"
)

func Run() {
	logger, _ := zap.NewProduction()
	defer logger.Sync() // flushes buffer, if any
	sugar := logger.Sugar()
	cfg, err := config.New()
	if err != nil {
		sugar.Error("error while defining config", err)
		return
	}
	db, err := connection.NewPostgresDB(cfg.DB)
	if err != nil {
		sugar.Error("error while defining db", err)
		return
	}

	repos := repository.NewRepository(db, sugar)
	handlers := handler.NewHandler(sugar, repos)
	srv := http.Server{
		Addr:    ":" + strconv.Itoa(cfg.App.Port),
		Handler: handlers.InitRoutes(),
	}
	errChan := make(chan error, 1)
	go func(errChan chan<- error) {
		sugar.Info("server on port: %d have started\n", cfg.App.Port)
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			sugar.Error(err)
			errChan <- err
		}
	}(errChan)

	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGTERM, syscall.SIGINT)

	select {
	case <-quit:
		sugar.Info("killing signal was received, shutting down the server")
	case err := <-errChan:
		sugar.Error("ERROR: HTTP server error received: %v", err)
	}

	log.Println("Shutting down server...")

	ctx, cancel := context.WithTimeout(context.Background(), cfg.App.TimeOut)
	defer cancel()
	if err := srv.Shutdown(ctx); err != nil {
		sugar.Error("WARN: Server forced to shutdown: %v", err)
	}
}
