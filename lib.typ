// Generates a US-style contractor invoice with hour tracking
#let invoice(
  // The invoice number
  invoice-nr,
  // The date on which the invoice was created
  invoice-date,
  // A list of items (each with description, hours, rate, optional discount)
  items,
  // Name and postal address of the author
  author,
  // Name and postal address of the recipient
  recipient,
  // Bank account details
  bank-account,
  // The text to display below the items
  invoice-text: "Thank you for your business. Payment is due within 14 days. Please remit payment to the account below, referencing the invoice number.",
  // Optional tax rate (e.g. 0.08 for 8% sales tax)
  tax-rate: 0.0,
  // Is the price of items including tax or excluding tax?
  includes-tax: false,
  // Optional note displayed below the invoice table about rates
  rate-note: "Hours and rates are provided for transparency. Please don't hesitate to reach out if you would like to discuss any adjustments.",
) = {
  set text(lang: "en", region: "US")

  set page(paper: "a4", margin: (x: 20%, y: 20%, top: 20%, bottom: 20%))

  let format_currency(number) = {
    let precision = 2
    assert(precision > 0)
    let s = str(calc.round(number, digits: precision))
    let after_dot = s.find(regex("\\..*"))
    if after_dot == none {
      s = s + "."
      after_dot = "."
    }
    for i in range(precision - after_dot.len() + 1){
      s = s + "0"
    }
    // Add thousands separators and dollar sign
    let parts = s.split(".")
    let int_part = parts.at(0)
    let dec_part = parts.at(1)
    let result = ""
    let count = 0
    for c in int_part.rev() {
      if count > 0 and calc.rem(count, 3) == 0 {
        result = "," + result
      }
      result = c + result
      count += 1
    }
    "$" + result + "." + dec_part
  }

  set text(number-type: "old-style")

  smallcaps[
    *#author.name* •
    #author.street •
    #author.city, #author.zip
  ]

  v(1em)

  [
    #set par(leading: 0.40em)
    #set text(size: 1.2em)
    #recipient.name \
    #recipient.street \
    #recipient.city, #recipient.zip
  ]

  v(4em)

  grid(columns: (1fr, 1fr), align: bottom, heading[
    Invoice \##invoice-nr
  ], [
    #set align(right)
    #author.city, *#invoice-date.display("[month]/[day]/[year]")*
  ])

  // Calculate item totals
  let item_totals = items.map((item) => {
    let hours = item.at("hours", default: 1)
    let rate = item.at("rate", default: item.at("price", default: 0))
    let discount = item.at("discount", default: 0)
    let base = hours * rate
    let disc_amount = base * discount
    let total = base - disc_amount
    (base: base, discount_amount: disc_amount, total: total, hours: hours, rate: rate, discount: discount, description: item.description)
  })

  let base_total = item_totals.map((i) => i.base).sum()
  let discount_total = item_totals.map((i) => i.discount_amount).sum()
  let subtotal = base_total - discount_total

  let tax_amount = if tax-rate > 0 and not includes-tax {
    subtotal * tax-rate
  } else {
    0.0
  }
  let final_total = subtotal + tax_amount

  let table_rows = item_totals.enumerate().map(
    ((id, item)) => {
      let disc_str = if item.discount > 0 {
        " (-" + str(calc.round(item.discount * 100)) + "%)"
      } else {
        ""
      }
      (
        [#str(id + 1).],
        [#item.description],
        [#str(item.hours)],
        [#format_currency(item.rate)/hr#disc_str],
        [#format_currency(item.total)],
      )
    }
  ).flatten()

  [
    #set text(number-type: "lining")
    #table(
      stroke: none,
      columns: (auto, 10fr, auto, auto, auto),
      align: ((column, row) => if column == 1 { left } else { right }),
      table.hline(stroke: (thickness: 0.5pt)),
      [*No.*], [*Description*], [*Hours*], [*Rate*], [*Amount*],
      table.hline(),
      ..table_rows, table.hline(),
      [],
      [
        #set align(end)
        Subtotal:
      ],
      [],
      [],
      [#format_currency(base_total)],
      table.hline(start: 4),
      ..if discount_total > 0 {(
        [],
        [
          #set align(end)
          Discount:
        ],
        [],
        [],
        [-#format_currency(discount_total)],
        table.hline(start: 4),
      )} else {([], [], [], [], [], [])},
      ..if tax-rate > 0 and not includes-tax {(
        [],
        [
          #set align(end)
          Tax (#str(tax-rate * 100)%):
        ],
        [],
        [],
        [#format_currency(tax_amount)],
        table.hline(start: 4),
      )} else {([], [], [], [], [], [])},
      [],
      [
        #set align(end)
        *Total:*
      ],
      [],
      [],
      [*#format_currency(final_total)*],
      table.hline(start: 4),
    )
  ]

  v(2em)

  [
    #set text(size: 0.8em)
    #invoice-text

    #v(0.5em)

    #emph(rate-note)
  ]

  v(1em)

  // Bank details for US
  grid(columns: (1fr, 1fr), gutter: 1em, align: top, [
    #set par(leading: 0.40em)
    #set text(number-type: "lining")
    Account Holder: #bank-account.name \
    Bank: #bank-account.bank \
    #if "routing" in bank-account [
      Routing No: *#bank-account.routing* \
    ]
    #if "account" in bank-account [
      Account No: *#bank-account.account* \
    ]
    #if "iban" in bank-account [
      IBAN: #bank-account.iban \
    ]
    #if "bic" in bank-account [
      BIC: #bank-account.bic \
    ]
  ], [])

  [
    Tax ID / EIN: #author.at("tax_id", default: author.at("tax_nr", default: "-"))

    #v(0.5em)

    Sincerely,

    #if "signature" in author [
      #scale(origin: left, x: 400%, y: 400%, author.signature)
    ] else [
      #v(1em)
    ]

    #author.name
  ]
}
