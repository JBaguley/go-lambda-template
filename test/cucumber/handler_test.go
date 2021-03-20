package cucmber

import (
	"context"
	"fmt"

	"github.com/JBaguley/go-lambda-template/internal/handler"
	"github.com/cucumber/godog"
)

var request handler.MyEvent
var response string
var err error

func iShouldSee(expected string) error {
	if response != expected {
		return fmt.Errorf("expected response was: %s, but received: %s", expected, response)
	}
	return nil
}

func invokeTheLambda() error {
	response, err = handler.HandleRequest(context.TODO(), request)
	if err != nil {
		return err
	}
	return nil
}

func myNameIs(name string) error {
	request = handler.MyEvent{Name: name}
	return nil
}

func InitializeScenario(ctx *godog.ScenarioContext) {
	ctx.BeforeScenario(func(*godog.Scenario) {
		request = handler.MyEvent{Name: ""}
		response = ""
		err = nil
	})
	ctx.Step(`^I should see "([^"]*)"$`, iShouldSee)
	ctx.Step(`^invoke the lambda$`, invokeTheLambda)
	ctx.Step(`^my name is "([^"]*)"$`, myNameIs)
}
