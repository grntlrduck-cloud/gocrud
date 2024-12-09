package book

import (
	"time"

	"github.com/segmentio/ksuid"
)

// In this scenario it is assumed the customer registration and
// data distribution is handled externally by another micoservice
type BookCustomer struct {
	Id             ksuid.KSUID
	Title          string
	FirstName      string
	SecondNames    []string
	LastName       string
	DateOfBirth    time.Time
	Address        *Address
	Contact        *Contact
	DefaultPayment Payment
}

type Address struct {
	Id          ksuid.KSUID
	StreetName  string
	HousNumber  string
	ZipCode     string
	City        string
	Province    string
	CountryCode string
}

type Contact struct {
	EMail string
	Phone string
}

type Payment string

const (
	CreditCard Payment = "CREDIT_CARD"
	Paypal     Payment = "PAYPAL"
	InstantPay         = "INSTANT_PAY"
	SEPA               = "SEPA"
)
