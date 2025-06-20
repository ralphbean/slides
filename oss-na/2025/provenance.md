name: inverse
layout: true
class: center, middle, inverse, title
---

# Not just ticking a box ☑️ 

## Establishing trust in artifacts with provenance 🔐🔗

### Open Source Summit - North America 2025

Andrew McNamara • Red Hat

Ralph Bean • Red Hat

.footnote[🔗 slides: [ralphbean.github.io/slides/oss-na/2025/provenance.html](https://ralphbean.github.io/slides/oss-na/2025/provenance.html)]

---
layout: false
.left-column[
  ## Meatspace Analogy
]
.right-column[

## When you buy something physical...

- 📍 Where was it assembled?
- 🏭 Where did its parts come from?
- 🌱 Did it meet blah organic criteria?
- 👩‍🔬 Which quality inspector assessed it?
- 📜 What certifications does it have?

.large[
You get this information **stamped on packaging** or **included in the box**.
]

]

---
.left-column[
  ## Meatspace Analogy
  ## Software Reality
]
.right-column[

## When you consume a software artifact in production...

.large[
Do you know its **provenance**?
]

- 🏗️ Where is this artifact from?
- ⚙️ How was it produced?
- 🧪 What checks ran against it?
- 👤 Who claims these facts?
- 🔒 Can you trust those claims?

.large[
We generally don't get this with software today.
]

]

---
layout: false
.left-column[
  ## Meatspace Analogy
  ## Software Reality
  ## What is Provenance?
]
.right-column[

## What is provenance?

For software artifacts (containers, packages, binaries):

- 📂 **Source**: What sources were provided to the build?
- 🔄 **Transformation**: What steps were applied before the build?
- 🏗️ **Build Process**: How was it built? Where? When?
- 🛡️ **Post-Build**: What happened to the artifact after that?
- ✅ **Verification**: What checks were performed?

.foonote[
Generally, **provenance** is the **origin** of something.
]

]

---
.left-column[
  ## Meatspace Analogy
  ## Software Reality
  ## What is Provenance?
  ## Why Care?
]
.right-column[

## Supply Chain Attacks are a Thing

- **SolarWinds** (2020): Build system compromised
- **Codecov** (2021): Bash uploader script compromised  
- **npm packages**: Malicious dependencies injected
- **PyPI typosquatting**: Fake packages with similar names

.large[
🎯 **Attackers target the build process because it's often less defended than the final product.**
]

]
---
.left-column[
  ## Meatspace Analogy
  ## Software Reality
  ## What is Provenance?
  ## Why Care?
  ## Threats
]
.right-column[

![](../../../common/supply-chain-threats.svg)

.footnote[*from the "Supply-chain Levels for Software Artifacts" or SLSA ("salsa") docs!]

]

---
.left-column[
  ## Meatspace Analogy
  ## Software Reality
  ## What is Provenance?
  ## Why Care?
  ## Threats
  ## Traditional Signing
]
.right-column[

## Traditional Software Signing is Limited

```
gpg --verify artifact.tar.gz.sig artifact.tar.gz
```

✅ **Identity**: Who signed this?  
❓ **Context**: What were they claiming when they signed it?

.large[
A signature just means **"it's good"** 

But good **how**? Good **why**?
]

]

---
template: inverse

# 📋 Enter: Attestations

---
layout: false
.left-column[
  ## Attestations
]
.right-column[

## in-toto Attestation Framework

.large[
An attestation is an **"I solemnly swear..."** statement
]

- 👤 **Who**: Identity making the claim (signed)
- 🔐 **Verification**: Cryptographically verifiable
- 📦 **What**: The artifact being described
- 📝 **Statement**: The specific claim being made

Instead of just "it's signed" → **"here's exactly what happened"**

]

---
.left-column[
  ## Attestations
  ## Predicate Types
]
.right-column[

## Different Types of Attestations

- 🏗️ **SLSA Provenance**: How was this built?
- 📋 **SBOM**: What components does this contain?
- 🛡️ **Vulnerability Scan**: What security issues exist?
- ✅ **Test Results**: What tests passed/failed?
- 📝 **Code Review**: Who approved the changes?

Each type answers different questions about your artifact.

]

---
layout: false
.left-column[
  ## Attestations
  ## Predicate Types
  ## sigstore & cosign
]
.right-column[

## cosign from the sigstore project

```
$ echo '{"hello": "world"}' > predicate.json

$ cosign attest \
    --type custom \
    --predicate predicate.json \
    quay.io/rbean/test:bsides

$ cosign verify-attestation \
    --certificate-identity ralph.bean@gmail.com \
    --certificate-oidc-issuer https://github.com/login/oauth \
    quay.io/rbean/test:bsides \
        | jq '.payload | @base64d | fromjson'
```

]
---
layout: false
.left-column[
  ## Attestations
  ## Predicate Types
  ## sigstore & cosign
  ## GitHub
]
.right-column[

## GitHub Actions Provenance

```yaml
jobs:
  build:
    steps:
      - uses: actions/checkout@v4
      - name: Build
        run: make build
      - uses: actions/attest-build-provenance@v1
        with:
          subject-path: './dist/app'
```

✅ **Source**: Commit SHA, repo URL  
✅ **Workflow**: Workflow file, inputs   
❓ **Materials**: Which actions?  
❓ **Data plane**: What does it mean to be sigend?

]
---
layout: false
.left-column[
  ## Attestations
  ## Predicate Types
  ## sigstore & cosign
  ## GitHub
]
.right-column[

## GitHub Actions Provenance

If there's network, show:

```
IMAGE=quay.io/lucarval/festoji@sha256:b508f3da1ba56f258d72da91c8ce07950ced85f142d81974022f61211c4a445a
oras blob fetch "$IMAGE" --output - | \
    jq '.dsseEnvelope.payload | @base64d | fromjson '
```

✅ **Source**: Commit SHA, repo URL  
✅ **Workflow**: Workflow file, inputs  
❓ **Materials**: Which actions?  
❓ **Data plane**: What does it mean to be signed?

]

---
.left-column[
  ## Attestations
  ## Predicate Types
  ## sigstore & cosign
  ## GitHub
  ## Witness
]
.right-column[

## Witness Framework

```bash
witness run -s build -- make build
witness run -s test -- make test  
witness run -s deploy -- kubectl apply -f app.yaml
```

✅ **Source**: Commit SHA, repo URL   
✅ **Detailed task execution**: How was it called  
✅ **Detailed materials**: What was used  
❓ **Data plane**: Payload signs itself  

]

---
.left-column[
  ## Attestations
  ## Predicate Types
  ## sigstore & cosign
  ## GitHub
  ## Witness
  ## Tekton
]
.right-column[

## Tekton Chains Provenance

```yaml
apiVersion: tekton.dev/v1beta1
kind: TaskRun
metadata:
  annotations:
    chains.tekton.dev/signed: "true"
spec:
  taskRef:
    name: git-clone
  params:
    - name: url
      value: https://github.com/example/repo
```

✅ **Source**: Commit SHA, repo URL  
✅ **Detailed task execution**: How was it called  
✅ **Detailed materials**: What was used  
✅ **Control plane**: Payload doesn't sign itself  

]

---
.left-column[
  ## Attestations
  ## Predicate Types
  ## sigstore & cosign
  ## GitHub
  ## Witness
  ## Tekton
]
.right-column[

## Tekton Chains Provenance

If there's network, show:

```
IMAGE=quay.io/bootc-devel/fedora-bootc-rawhide-standard:20250605-110837
cosign download attestation $IMAGE  2> /dev/null | \
    jq '.payload | @base64d | fromjson '
```

✅ **Source**: Commit SHA, repo URL  
✅ **Detailed task execution**: How was it called  
✅ **Detailed materials**: What was used  
✅ **Control plane**: Payload doesn't sign itself  

]


---
template: inverse

# 🏗️ Konflux: My Project

---
layout: false
.left-column[
  ## Konflux: My Project
]
.right-column[

## Konflux: Secure Software Factory

.large[
**Open source**, **cloud native** software factory focused on **supply chain security**.
]

- 🔧 **Kubernetes-based**: Everything as Custom Resources
- 🏗️ **Comprehensive**: Build → Test → Release pipeline
- 🛡️ **Security-first**: Attestations throughout the process
- 📊 **Policy-driven**: Machine-readable policies gate releases
- 📋 **SBOM**: Novel manifest generation with "Hermeto".

.footnote[
**Each step creates verifiable evidence**
]

]

---
.left-column[
  ## Konflux: My Project
  ## Policy Gates
]
.right-column[

## conforma: Policy-Based Gating

```rego
deny contains result if {
  some required_task in _missing_tasks(current_required_tasks.tasks)

  # Don't report an error if a task is required now, but not in the future
  required_task in latest_required_tasks.tasks
  result := lib.result_helper_with_term(
    rego.metadata.chain(),
    [_format_missing(required_task, false)],
    required_task
  )
}
```

**Machine-readable policies** decide what gets released.

]

---
layout: false
.left-column[
  ## Konflux: My Project
  ## Policy Gates
  ## Doing Stuff
]
.right-column[

## Stuff you can do

### 📊 **Compliance & Auditing**  
- Prove security practices were followed
- Generate audit reports automatically

### 🔍 **Incident Response**
- Trace back to root cause
- Understand blast radius

### 🧬 **Evolve Posture**
- Block artifacts out of compliance
- Encode schedules in the policies

]

---
.left-column[
  ## Konflux: My Project
  ## Policy Gates
  ## Doing Stuff
  ## Innovation (last slide)
]
.right-column[

## Enabling Safe Innovation

.large[
**One way**: Make insecure things impossible
]

- 🐢 Innovation is slow
- 🤷 Change gatekeepers may not understand needs  
- 🏃‍♀️ Devs circumvent restrictions, defeating the purpose

.large[
**Another way**: Define what "good" looks like
]

- ✅ Clear requirements for release
- 🧪 Freedom to experiment in development
- 🚀 Fast feedback loop

]

---
template: inverse

# Ok.

---
name: last-page
template: inverse

## 🔗 Resources & Questions

**Blog**: [How we use software provenance at Red Hat](https://developers.redhat.com/articles/2025/05/15/how-we-use-software-provenance-red-hat)

**sigstore project**: [sigstore.dev](https://www.sigstore.dev/)

**in-toto Attestations**: [in-toto.io](https://in-toto.io)

**SLSA Framework**: [slsa.dev](https://slsa.dev)

**Conforma**: [conforma.dev](https://conforma.dev)

**Try Konflux**: [konflux-ci.dev](https://konflux-ci.dev)

**slides**: [ralphbean.github.io/slides/oss-na/2025/provenance.html](https://ralphbean.github.io/slides/oss-na/2025/provenance.html)

---

name: inverse
layout: true
class: center, middle, inverse, title
---

# Thanks!

.footnote[Andrew McNamara • Ralph Bean]
