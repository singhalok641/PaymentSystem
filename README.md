# Payment System — Learn by Building

A Java and Spring Boot learning project that explores what happens after a customer clicks **Pay**.

We are building the merchant side of a payment integration: accepting a checkout, recording what needs to be paid, asking a payment service provider (PSP) to process payments, and recording the results. MySQL will store our application data. Adyen's test environment is the planned PSP integration.

The project grows one lesson at a time. Each lesson explains a problem, implements a small part of the solution, and explores what happens when something fails. You should be comfortable with basic Java, REST APIs, and SQL; no previous payment-system experience is required.

This is an educational project using test payments. It is not ready to process real money and is not an official Adyen project.

## Start with an example

A buyer checks out with items from two sellers:

```text
Checkout: one buyer's request
├── Payment order A: collect EUR 30.00 for seller A
└── Payment order B: collect EUR 20.00 for seller B
```

**Each payment order will produce a separate charge.** One charge may succeed while another fails. We will learn how to represent that partial success and recover safely without charging a buyer twice.

The first lesson only records these instructions. Saving a payment order does not charge a card.

## The main concepts

| Concept | What it means here |
| --- | --- |
| Checkout | Groups the payment orders submitted together by a buyer. |
| Payment order | An instruction to collect a specific amount for one seller. |
| Payment attempt | One execution attempt for an order through a PSP. A network retry must not automatically become a new attempt. |
| PSP | An external provider that processes payments through the relevant financial infrastructure. |
| Webhook | A notification sent by the PSP to our backend about a payment event. |
| Ledger | A financial record whose entries explain changes in money owed and held. We will use double-entry accounting. |
| Merchant balance | A view of the amounts attributed to a seller, backed by ledger records. |

Authorisation, capture, and settlement are different stages. A successful authorisation does not mean the seller has received available funds. We will introduce each stage when we implement it.

## Where we are today

The repository currently contains:

- A Spring Boot application starter and an application-context test.
- Maven configuration targeting Java 25 and Spring Boot 4.1.1.
- Spring MVC, the MySQL JDBC driver, Lombok, and development tools.
- MySQL connection settings in `src/main/resources/application.yml`.
- An initial schema in `src/main/resources/db/migration/V1__create_payment_tables.sql`.

**There are no payment endpoints or PSP calls yet.** The build does not yet include JPA/JDBC persistence starters or Flyway. The schema file is therefore not automatically applied, and the JPA configuration does not yet establish a working persistence layer.

## Our first lesson: persist the intent

Before calling a PSP, we need a durable record of what we intend to collect.

We will save a checkout and all its payment orders in a single database transaction. Either all those records are saved, or none are. This lets us recover accepted work after an application restart.

That database transaction cannot make multiple external charges succeed together, and it cannot undo a PSP charge.

The first milestone will demonstrate:

1. Creating a checkout and its payment orders atomically.
2. Returning the existing checkout when an identical request is repeated.
3. Rejecting reuse of the same checkout ID with different instructions.
4. Handling concurrent duplicate requests using database constraints.

Initially, we support EUR and store amounts as integer cents: `3000` means EUR 30.00. We do not use floating-point types for money.

## How the project will grow

These are planned milestones, not implemented features.

| Lesson | What we will build and understand |
| --- | --- |
| 1. Durable payment instructions | Checkout and order persistence, transactions, and duplicate requests. |
| 2. Payment execution | Attempts, PSP integration, idempotency keys, and ambiguous timeouts. |
| 3. Browser checkout | Payment UI, shopper actions, and return URLs. |
| 4. Payment notifications | Webhook verification, durable receipt, duplicates, and status updates. |
| 5. Financial records | Double-entry ledger and merchant balances that stay consistent. |
| 6. Recovery and lifecycle | Failed payments, reconciliation, capture, cancellation, and refunds. |
| 7. Scaling | Concurrency, background processing, and growth toward larger workloads. |

We start with one Spring Boot application and one MySQL database. Payment orchestration, PSP execution, ledger, and balances will have clear responsibilities within that application. Deployment boundaries can evolve as we learn.

## Run the starter

### Prerequisites

- JDK 25, matching the project's Maven configuration.
- Internet access for Maven dependency downloads.
- MySQL when working on the persistence lesson; it is not yet wired into the starter's application logic.

A Maven installation is optional because the repository includes the Maven Wrapper.

From the repository root, check which Java version the wrapper uses:

```bash
java -version
./mvnw -version
```

Both should use JDK 25. If they differ, check `JAVA_HOME` and your IDE's project and Maven JDK settings.

Run the current tests and start the application:

```bash
./mvnw test
./mvnw spring-boot:run
```

On Windows, use `mvnw.cmd` instead of `./mvnw`.

The default web port is `8080`. No home page or business endpoint exists yet, so a `404` at `http://localhost:8080/` is expected. Starting the web application alone does not verify a database connection or a payment flow.

### Database configuration for the next step

The configuration points to a local database named `payment_system`:

```text
jdbc:mysql://localhost:3306/payment_system
```

It reads credentials from `DB_USERNAME` and `DB_PASSWORD`. Set these in your local environment or IDE run configuration when we wire up persistence. Do not commit actual credentials.

We will add the persistence and migration dependencies, create the local database, and verify schema migration during the first implementation lesson. Do not assume the SQL file runs merely because it is in a `db/migration` directory.

## Repository guide

```text
pom.xml                              Dependencies and Java version
mvnw / mvnw.cmd                      Maven Wrapper launchers
src/main/java/                       Application source
src/main/resources/application.yml   Application configuration
src/main/resources/db/migration/     Initial SQL schema
src/test/java/                       Tests
contributing.md                      How to contribute and learn together
```

## Learn and contribute

For each change, ask: What problem does this solve? What happens if the request is repeated? What happens if the process crashes halfway through?

Questions, clearer explanations, tests, and small implementation improvements are welcome. Read [the contributing guide](contributing.md) before submitting a change.

As lessons are completed, we will update this README with working examples and setup instructions that match the code.
