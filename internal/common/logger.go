// Package common provides some useful functions and objects that
// may be used across all the components implemented in this project
// One example is the default logger
package common

import (
	"log"

	"go.uber.org/zap"
)

type LogCfg int

const (
	Dbg LogCfg = iota
	Prod
)

var Logger *zap.SugaredLogger = ConfigGlobalLogger(Dbg)

func ConfigGlobalLogger(cfg LogCfg) *zap.SugaredLogger {
	var logger *zap.Logger
	var err error

	switch cfg {
	case Dbg:
		logger, err = zap.NewDevelopment()
	case Prod:
		logger, err = zap.NewProduction()
	default:
		log.Fatalf("Invalid log config %d", cfg)
	}

	if err != nil {
		log.Fatalf("Failed to initialize logger: %v", err)
	}

	return logger.Sugar()
}
