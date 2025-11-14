# Prismatic Component Publisher

This GitHub Action publishes a component via Prismatic's Prism CLI.

## Inputs

- **COMPONENT_PATH** (optional): The path to the component's index.ts/js file. If not provided, the root will be used.
- **CUSTOMER_ID** (optional): The ID of the customer with which to associate the component.
- **PRISMATIC_URL** (required): The target Prismatic API to publish to.
- **PRISM_REFRESH_TOKEN** (required): The token granting access to the API at the PRISMATIC_URL provided.
- **PRISMATIC_TENANT_ID** (optional): The tenant ID to use when publishing the integration. Required if your user is associated with multiple tenants in a single region. Use `prism me` to find your tenant ID.
- **COMMENT** (optional): Any comments to associate with the component.
- **SKIP_COMMIT_HASH_PUBLISH** (optional): Skip inclusion of commit hash in metadata. Default is `false`.
- **SKIP_COMMIT_URL_PUBLISH** (optional): Skip inclusion of commit URL in metadata. Default is `false`.
- **SKIP_REPO_URL_PUBLISH** (optional): Skip inclusion of repository URL in metadata. Default is `false`.
- **SKIP_PULL_REQUEST_URL_PUBLISH** (optional): Skip inclusion of pull request URL in metadata. Default is `false`.

## Example Usage

To use this action in your workflow, add the following step configuration to your workflow file (this assumes that `PRISMATIC_URL` is stored in a Github environment's `variables` and that `PRISM_REFRESH_TOKEN` is stored in the same environment's `secrets`):

```yaml
- name: <STEP NAME>
  uses: prismatic-io/component-publisher@v1.0
  with:
    COMPONENT_PATH: src/my-component
    PRISMATIC_URL: ${{ vars.PRISMATIC_URL }}
    PRISM_REFRESH_TOKEN: ${{ secrets.PRISM_REFRESH_TOKEN }}
    PRISMATIC_TENANT_ID: ${{ vars.PRISMATIC_TENANT_ID }}
```

Optional inputs can be passed via the `with` block as desired.

### Additional Workflow Steps

The following steps are an example of preparing the component bundle prior to publishing via this action.

```yaml
- uses: actions/checkout@v4

- name: Install dependencies
  run: npm install
  working-directory: src/my-component

- name: Build component bundle
  run: npm run build
  working-directory: src/my-component
```

## Acquiring PRISM_REFRESH_TOKEN and PRISMATIC_TENANT_ID

To acquire a refresh token that will authenticate against the Prism CLI, run this command in a terminal (assuming you are authenticated with the CLI):

```
prism me:token --type=refresh
```

This will produce a token valid for the Prismatic stack that your CLI is currently configured to.

To check which API Prism is currently configured for, and to fetch your tenant ID, run:

```
prism me
```

## What is Prismatic?

Prismatic is the leading embedded iPaaS, enabling B2B SaaS teams to ship product integrations faster and with less dev time. The only embedded iPaaS that empowers both developers and non-developers with tools for the complete integration lifecycle, Prismatic includes low-code and code-native building options, deployment and management tooling, and self-serve customer tools.

Prismatic's unparalleled versatility lets teams deliver any integration from simple to complex in one powerful platform. SaaS companies worldwide, from startups to Fortune 500s, trust Prismatic to help connect their products to the other products their customers use.

With Prismatic, you can:

- Build [integrations](https://prismatic.io/docs/integrations/) using our [intuitive low-code designer](https://prismatic.io/docs/integrations/low-code-integration-designer/) or [code-native](https://prismatic.io/docs/integrations/code-native/) approach in your preferred IDE
- Leverage pre-built [connectors](https://prismatic.io/docs/components/) for common integration tasks, or develop custom connectors using our TypeScript SDK
- Embed a native [integration marketplace](https://prismatic.io/docs/embed/) in your product for customer self-service
- Configure and deploy customer-specific integration instances with powerful configuration tools
- Support customers efficiently with comprehensive [logging, monitoring, and alerting](https://prismatic.io/docs/monitor-instances/)
- Run integrations in a secure, scalable infrastructure designed for B2B SaaS
- Customize the platform to fit your product, industry, and development workflows

## Who uses Prismatic?

Prismatic is built for B2B software companies that need to provide integrations to their customers. Whether you're a growing SaaS startup or an established enterprise, Prismatic's platform scales with your integration needs.

Our platform is particularly powerful for teams serving specialized vertical markets. We provide the flexibility and tools to build exactly the integrations your customers need, regardless of the systems you're connecting to or how unique your integration requirements may be.

## What kind of integrations can you build using Prismatic?

Prismatic supports integrations of any complexity - from simple data syncs to sophisticated, industry-specific solutions. Teams use it to build integrations between any type of system, whether modern SaaS or legacy with standard or custom protocols. Here are some example use cases:

- Connect your product with customers' ERPs, CRMs, and other business systems
- Process data from multiple sources with customer-specific transformation requirements
- Automate workflows with customizable triggers, actions, and schedules
- Handle complex authentication flows and data mapping scenarios

For information on the Prismatic platform, check out our [website](https://prismatic.io/) and [docs](https://prismatic.io/docs/).

## License

This repository is MIT licensed.
