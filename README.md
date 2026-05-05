# US Contractor Invoice Template

A template for writing contractor invoices in the US, originally inspired by the [beautiful LaTeX template by @mrzool](https://github.com/mrzool/invoice-boilerplate/) and the [classy-german-invoice](https://github.com/erictapen/typst-invoice) Typst template.

## Features

- Hour tracking with transparent rates
- Automatic calculation of line-item totals
- Optional per-item discounts (shown inline on the rate)
- Configurable sales tax
- US English language and date formatting (`MM/DD/YYYY`)
- USD currency formatting
- Configurable rate-negotiation note

## Usage

```typ
#import "/lib.typ": invoice

#show: invoice(
  // Invoice number
  "2024-001",
  // Invoice date
  datetime(year: 2024, month: 09, day: 03),
  // Items (hours × rate = amount)
  (
    (
      description: "Project planning",
      hours: 8.0,
      rate: 150.00,
    ),
    (
      description: "Development",
      hours: 12.5,
      rate: 150.00,
      discount: 0.10, // 10% discount applied
    ),
  ),
  // Author
  (
    name: "Your Name",
    street: "123 Main St",
    city: "Anytown",
    zip: "12345",
    tax_id: "12-3456789",
    signature: image("example_signature.png", width: 5em)
  ),
  // Recipient
  (
    name: "Client Company, Inc.",
    street: "456 Business Blvd",
    city: "Commerce City",
    zip: "67890",
  ),
  // Bank account
  (
    name: "Your Name",
    bank: "Chase Bank",
    routing: "021000021",
    account: "1234567890",
  ),
  // Sales tax rate (set to 0.0 if not applicable)
  tax-rate: 0.0,
  // Optional note about rate flexibility
  rate-note: "Hours and rates are provided for transparency. Please don't hesitate to reach out if you would like to discuss any adjustments.",
)
```

## Item Fields

| Field       | Required | Description                                                            |
|-------------|----------|------------------------------------------------------------------------|
| `description` | Yes    | Description of the work performed                                      |
| `hours`       | No (defaults to 1)     | Hours worked                                       |
| `rate`        | No (defaults to `price` or 0) | Hourly rate in USD                      |
| `price`       | No (legacy) | Total price for the line item (used if `rate` is omitted)             |
| `discount`    | No (defaults to 0) | Discount as a decimal (e.g. 0.10 for 10%)                            |

## Disclaimer

This template doesn't constitute legal or tax advice. Please check for yourself whether it fulfills your requirements!
