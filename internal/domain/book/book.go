package book

import (
	"time"

	"github.com/segmentio/ksuid"
)

type Book struct {
	Id           ksuid.KSUID
	Title        string
	Release      time.Time
	FirstRelease time.Time
	Authors      []BookAuthor
	Genres       []BookGenere
	Series       string
	Edition      int32
	Price        float64
	Discounts    []DiscountCode
	Available    int32
	Status       InventoryState
}

type BookAuthor struct {
	Id          ksuid.KSUID
	Title       string
	FirstName   string
	SecondNames []string
	LastName    string
	DateOfBirth time.Time
	DateOfDeaht time.Time
}

type BookGenere struct {
	Id   ksuid.KSUID
	Name string
}

type BookSeries struct {
	Id         ksuid.KSUID
	SeriesName string
}

type DiscountCode struct {
	Id                 ksuid.KSUID
	PercentageDiscount int32
	From               time.Time
	To                 time.Time
	Code               string
}

type InventoryState string

const (
	Available  InventoryState = "available"
	ReOrdered  InventoryState = "re-ordered"
	OutOfStock InventoryState = "out-of-stock"
)

type BookOrder struct {
	Id           ksuid.KSUID
	BookId       ksuid.KSUID
	Quantity     int32
	ShippingDate time.Time
}

type OrderState string

const (
	OrderStatePlaced    OrderState = "placed"
	OrderStateShipped   OrderState = "shipped"
	OrderStateDelivered OrderState = "delivered"
	OrderStateCanceled  OrderState = "canceled"
)
