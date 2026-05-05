#import "../lib.typ": invoice

#show: invoice(
  // Invoice number
  "2024-001",
  // Invoice date
  datetime(year: 2024, month: 09, day: 03),
  // Items (hours × rate = amount)
  (
    (
      description: "Initial project planning and requirements gathering",
      hours: 8.0,
      rate: 150.00,
    ),
    (
      description: "Development — frontend implementation",
      hours: 12.5,
      rate: 150.00,
    ),
    (
      description: "Development — backend API integration",
      hours: 10.0,
      rate: 150.00,
      discount: 0.10, // 10% courtesy discount
    ),
    (
      description: "Code review and documentation",
      hours: 3.5,
      rate: 150.00,
    ),
  ),
  // Author
  (
    name: "Your Name",
    street: "123 Main St",
    city: "Anytown",
    zip: "12345",
    tax_id: "12-3456789",
    // optional signature, can be omitted
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
  // Tax rate (set to 0.0 if not applicable)
  tax-rate: 0.0,
  // Optional note about rate flexibility
  rate-note: "Hours and rates are provided for transparency. Please don't hesitate to reach out if you would like to discuss any adjustments.",
)
