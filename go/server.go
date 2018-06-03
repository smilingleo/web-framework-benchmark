package main

import (
	"net/http"

	"github.com/labstack/echo"
)

type (
	data struct {
		Name   string `json:"name"`
		Number int    `json:"id"`
	}
)

func postData(c echo.Context) error {
	d := &data{}
	if err := c.Bind(d); err != nil {
		return err
	}
	return c.JSON(http.StatusOK, d)
}

func main() {
	e := echo.New()

	e.POST("/post-data", postData)
	e.Start(":8080")
}
