name: inverse
layout: true
class: center, middle, inverse, title
---
<img class="logo" src='https://konflux-ci.dev/img/logo.svg'/><br/>

## Secure Builds Made Easy

.footnote[[konflux-ci.dev](https://konflux-ci.dev)]
---
layout: false
.left-column[
  ## What is it?
]
.right-column[
.large[
  Konflux is an opinionated, Kubernetes-native, security first software factory based on Tekton.
]

### What can I build on Konflux?

You can build just about **anything** in Konflux. You are only limited by what Tekton tasks you can create. 

Already, we build containers on multiple architectures, manifest lists, Terraform modules, Mac binaries…

RPMs, JARs, WARs, and binaries from nearly any language are all possible.

]
---
.left-column[
  ## What is it?
  ## Secure?
]
.right-column[

### Is everything Konflux builds secure?

No. You can build nearly anything you want in nearly any way you want.  That means it is possible to:

- Use insecure base images

- Pull in random content from the internet 

- Use build tasks from unknown authors

- …all manner of other ill-advised actions

]
---
.left-column[
  ## What is it?
  ## Secure?
  ## The problem
]
.right-column[

### The problem with rigid build systems

- Innovation is slow because there are relatively few people who can make changes

- Early stage projects, prototypes & upstream projects use other systems because restrictions are unworkable (e.g. limited base images, limited internet access..)

- Onboarding later is painful and often causes a regression in functionality (like moving from Github Actions -> Brew / PNC / OSBS)

]
---
.left-column[
  ## What is it?
  ## Secure?
  ## The problem
  ## So...?
]
.right-column[

### So what do you mean by secure?

- We can define the characteristics that define 'secure' to us, and determine if they are true for any artifact produced.

- Konflux will prevent any artifact which does meet the policy requirements from being released.

- Different artifact requirements can be  specified for different artifact types, different release destinations, different workspaces… in any way which is needed.

### How do you tell 'good' builds from 'bad' builds?

- We use [Tekton Chains](https://tekton.dev/docs/chains/), together with [Enterprise Contract](https://enterprisecontract.dev/), to determine if an artifact meets the required policy.

> "Tekton Chains is a Kubernetes Custom Resource Definition (CRD) controller that allows you to manage your supply chain security in Tekton.
> In its default mode of operation, Chains works by observing all TaskRuns executions in your cluster. When TaskRuns complete, Chains takes a snapshot of them. Chains then converts this snapshot to one or more standard payload formats, signs them and stores them somewhere."

]
---
template: inverse

## It's time to get started!
---
.left-column[
  ## Getting started
]
.right-column[
Outro material goes here.
]
---
name: last-page
template: inverse

## That's all folks (for now)!
