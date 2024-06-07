# Prismatic Component Publisher

This GitHub Action publishes a component via Prismatic's Prism CLI.

## Inputs

- **PRISMATIC_URL** (required): The target Prismatic API to publish to.
- **PRISM_REFRESH_TOKEN** (required): The token granting access to the API at the PRISMATIC_URL provided.
- **CUSTOMER_ID** (optional): The ID of the customer with which to associate the component.
- **COMMENT** (optional): Any comments to associate with the component.
- **SKIP_COMMIT_HASH_PUBLISH** (optional): Skip inclusion of commit hash in metadata. Default is `false`.
- **SKIP_COMMIT_URL_PUBLISH** (optional): Skip inclusion of commit URL in metadata. Default is `false`.
- **SKIP_REPO_URL_PUBLISH** (optional): Skip inclusion of repository URL in metadata. Default is `false`.
- **SKIP_PULL_REQUEST_URL_PUBLISH** (optional): Skip inclusion of pull request URL in metadata. Default is `false`.

## Example Usage

To use this action in your workflow, add the following step configuration to your workflow file (this assumes that `PRISMATIC_URL` is stored in a Github environment's `variables` and that `PRISM_REFRESH_TOKEN` is stored in the same environment's `secrets`):

```yaml
  - name: <STEP NAME>
    uses: prismatic-io/component-publisher@v1
    with:
      PRISMATIC_URL: ${{ vars.PRISMATIC_URL }}
      PRISM_REFRESH_TOKEN: ${{ secrets.PRISM_REFRESH_TOKEN }}
```
Optional inputs can be passed via the `with` block as desired. 

## Acquiring PRISM_REFRESH_TOKEN

To acquire a refresh token that will authenticate against the Prism CLI, run this command in a terminal (assuming you are authenticated with the CLI):
```
prism me:token --type=refresh
```
This will produce a token valid for the Prismatic stack that your CLI is currently configured to. To check which API Prism is currently configured for, run:
```
prism me
```

## What is Prismatic?

Prismatic is the integration platform for B2B software companies. It's the quickest way to build integrations to the other apps your customers use and to add a native integration marketplace to your product.

Prismatic significantly reduces overall integration effort and enables non-dev teams to take on more of the integration workload, so that you can deliver integrations faster and spend more time on core product innovation.

With Prismatic, you can:

- Build reusable [integrations](https://prismatic.io/docs/integrations) in a low-code integration designer that's tailored for your product
- Use [pre-built components](https://prismatic.io/docs/components/component-catalog) to handle most of your integrations' functionality, and write [custom components](https://prismatic.io/docs/custom-components/writing-custom-components) when needed
- Quickly add an [integration marketplace](https://prismatic.io/docs/integration-marketplace) to your product so customers can explore, activate, and monitor integrations
- Easily deploy customer-specific integration [instances](https://prismatic.io/docs/instances) with unique configurations and connections
- Provide better support with tools like [logging](https://prismatic.io/docs/logging) and [alerting](https://prismatic.io/docs/monitoring-and-alerting)
- Run your integrations in a purpose-built environment designed for security and scalability
- Use powerful dev tools to mold the platform to your product, industry, and the way you build software

## Who uses Prismatic?

Prismatic is for B2B (business-to-business) software companies, meaning software companies that provide applications used by businesses. It's a good fit for products/teams ranging from early-stage and growing SaaS startups to large, established software companies looking to improve the way they do integrations.

Many B2B software teams serve customers in niche vertical markets, and we designed Prismatic with that in mind. We provide powerful and flexible tools so you can build exactly the integrations your customers need, no matter who your customers are, no matter what systems you need to connect to, no matter how "non-standard" your integration scenario.

## What kind of integrations can you build using Prismatic?

Prismatic supports integrations ranging from simple and standard to complex, bespoke, and vertical-specific.
Teams use it to build integrations between applications of all kinds, SaaS or legacy, with or without a modern API, regardless of protocol or data format.
Here are some example use cases:

- Use job data from your system to create invoices in your customers' ERP.
- Import and process data from third-party forms that vary significantly from customer to customer.
- Email activity summary reports with parameters and intervals defined on a per-customer basis.

For information on the Prismatic platform, check out our [website](https://prismatic.io) and [docs](https://prismatic.io/docs).
