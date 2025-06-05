name: inverse
layout: true
class: center, middle, inverse, title
---

# Establishing Trust in Artifacts with Provenance

### BSides Buffalo 2025

Ralph Bean • Red Hat

.footnote[🔗 slides at: your-url-here]

---
template: inverse

# 🤔 The Question

---
layout: false
.left-column[
  ## The Question
]
.right-column[

## When you buy something physical...

- 📍 Where was it assembled?
- 🏭 Where did its parts come from?
- 🌱 Did it meet organic criteria?
- 👩‍🔬 Which quality inspector assessed it?
- 📜 What certifications does it have?

.large[
You get this information **stamped on packaging** or **included in the box**.
]

]

---
.left-column[
  ## The Question
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

]

---
template: inverse

# 📦 What is Provenance?

---
layout: false
.left-column[
  ## What is Provenance?
]
.right-column[

.large[
**Provenance** is the **origin** of something.
]

For software artifacts (containers, packages, binaries):

- 📂 **Source**: What sources were provided to the build?
- 🔄 **Transformation**: What steps were applied before the build?
- 🏗️ **Build Process**: How was it built? Where? When?
- 🛡️ **Post-Build**: What happened to the artifact after the build?
- ✅ **Verification**: What checks were performed?

]

---
.left-column[
  ## What is Provenance?
  ## Why Care?
]
.right-column[

## Supply Chain Attacks are Real

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
  ## What is Provenance?
  ## Why Care?
  ## Current State
]
.right-column[

## Traditional Software Signing is Limited

```
gpg --verify artifact.tar.gz.sig artifact.tar.gz
```

✅ **Identity**: Who signed this?  
❌ **Context**: What were they claiming when they signed it?

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
- 📦 **What**: The artifact being described
- 📝 **Statement**: The specific claim being made
- 🔐 **Verification**: Cryptographically verifiable

Instead of just "it's signed" → **"here's exactly what happened"**

]

---
.left-column[
  ## Attestations
  ## Structure
]
.right-column[

## Attestation Anatomy

```json
{
  "payloadType": "application/vnd.in-toto+json",
  "payload": "<base64-encoded-statement>",
  "signatures": [
    {
      "keyid": "...",
      "sig": "..."
    }
  ]
}
```

The **statement** contains:
- **Subject**: The artifact being described
- **Predicate**: The claim being made about it

]

---
.left-column[
  ## Attestations
  ## Structure
  ## Provenance Types
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
template: inverse

# 🔍 Provenance in Practice

---
layout: false
.left-column[
  ## Practice
]
.right-column[

## GitHub Actions Provenance

```yaml
jobs:
  build:
    permissions:
      id-token: write  # for OIDC
      contents: read
      attestations: write
    steps:
      - uses: actions/checkout@v4
      - name: Build
        run: make build
      - uses: actions/attest-build-provenance@v1
        with:
          subject-path: './dist/app'
```

✅ **Identity**: GitHub's signing key  
✅ **Source**: Commit SHA, repo URL  
✅ **Workflow**: Workflow file, inputs  

]

---
.left-column[
  ## Practice
  ## GitHub vs Tekton
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

✅ **Kubernetes-native**  
✅ **Detailed task execution**  
✅ **Parameter tracking**  
✅ **Results recording**  

]

---
.left-column[
  ## Practice
  ## GitHub vs Tekton
  ## Witness
]
.right-column[

## Witness Framework

```bash
witness run -s build -- make build
witness run -s test -- make test  
witness run -s deploy -- kubectl apply -f app.yaml
```

✅ **Policy-driven**  
✅ **Multi-step workflows**  
✅ **Environment capture**  
✅ **Flexible attestation types**  

Each tool has different strengths for different use cases.

]

---
template: inverse

# 🏗️ Red Hat's Approach

---
layout: false
.left-column[
  ## Red Hat's Approach
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

]

---
.left-column[
  ## Red Hat's Approach
  ## Attestations Everywhere
]
.right-column[

## Attestations Throughout the Pipeline

- 🏗️ **Build attestation**: How was it built?
- 📋 **SBOM**: What's inside?
- 🛡️ **Vulnerability scan**: Security status
- 🧪 **Test results**: Quality metrics
- ✅ **Policy verification**: Compliance status

.large[
**Each step creates verifiable evidence**
]

]

---
.left-column[
  ## Red Hat's Approach
  ## Attestations Everywhere
  ## Policy Gates
]
.right-column[

## Conforma: Policy-Based Gating

```rego
# Was a CVE scan performed?
allow {
    vuln_attestations := input.attestations[_]
    vuln_attestations.predicate.scanType == "vulnerability"
    vuln_attestations.predicate.results.critical < 5
}

# Was this built with a trusted task?
allow {
    build_attestation := input.attestations[_]  
    build_attestation.predicate.buildType == "tekton.dev/v1beta1/TaskRun"
    build_attestation.predicate.builder.id in trusted_builders
}
```

**Machine-readable policies** decide what gets released.

]

---
template: inverse

# 🛠️ Practical Benefits

---
layout: false
.left-column[
  ## Benefits
]
.right-column[

## What You Can Do With Provenance

### 🔍 **Incident Response**
- Quickly identify affected artifacts
- Trace back to root cause
- Understand blast radius

### 📊 **Compliance & Auditing**  
- Prove security practices were followed
- Generate audit reports automatically
- Meet regulatory requirements

### 🛡️ **Security Posture**
- Block artifacts with known vulnerabilities
- Ensure required security scans ran
- Verify trusted build environments

]

---
.left-column[
  ## Benefits
  ## Innovation
]
.right-column[

## Enabling Safe Innovation

.large[
**Traditional approach**: Make insecure things impossible
]

- 🐢 Innovation is slow
- 🤷 Change gatekeepers may not understand needs  
- 🏃‍♀️ Users circumvent restrictions

.large[
**Provenance approach**: Define what "good" looks like
]

- ✅ Clear requirements for release
- 🧪 Freedom to experiment in development
- 🚀 Fast feedback loop

]

---
template: inverse

# 🚀 Getting Started

---
layout: false
.left-column[
  ## Getting Started
]
.right-column[

## Questions to Ask Yourself

### 📋 **Inventory**
- What artifacts do you build?
- Where are they built?
- Who has access to the build process?

### 🎯 **Requirements**  
- What compliance requirements do you have?
- What security properties matter?
- What would "good enough" look like?

### 🔧 **Tooling**
- What build systems do you use?
- Can they generate attestations?
- Where would you store and verify them?

]

---
.left-column[
  ## Getting Started
  ## First Steps
]
.right-column[

## Start Small, Think Big

### 1. **Pick One Artifact** 🎯
Start with your most critical or sensitive component

### 2. **Generate Basic Provenance** 📝
Use your existing CI/CD system's attestation features

### 3. **Verify Manually** 🔍
Learn what the attestations contain and mean

### 4. **Write Simple Policies** 📜
Start with basic requirements (e.g., "must have SBOM")

### 5. **Automate Verification** ⚙️
Build verification into your deployment pipeline

### 6. **Expand Coverage** 📈
Add more artifacts and more detailed requirements

]

---
.left-column[
  ## Getting Started
  ## First Steps
  ## Tools to Try
]
.right-column[

## Tools to Explore

### **For GitHub Users** 🐱
- `actions/attest-build-provenance`
- `gh attestation verify`

### **For Kubernetes Users** ☸️
- Tekton Chains
- Sigstore Cosign
- SLSA GitHub Generator

### **For Policy Management** 📜
- Conforma (Red Hat)
- Open Policy Agent (OPA)
- Sigstore Policy Controller

### **For General Use** 🛠️
- Witness framework
- in-toto tools
- SLSA generators

]

---
template: inverse

# ❓ Questions to Ponder

---
layout: false
.left-column[
  ## Questions
]
.right-column[

## Real-World Considerations

### 🤝 **Trust Models**
- Who do you trust to make attestations?
- How do you verify the attesters themselves?
- What happens when trust relationships change?

### 📈 **Scale & Performance**
- How many attestations per artifact?
- Where do you store them long-term?
- How do you query them efficiently?

### 🔄 **Evolution & Maintenance**
- How do policies evolve over time?
- What happens to old attestations?
- How do you handle legacy artifacts?

]

---
template: inverse

# 🎯 Key Takeaways

---
layout: false
.left-column[
  ## Takeaways
]
.right-column[

.large[
**1. Provenance is about trust, not just compliance** 🤝
]

Know where your software comes from and how it was built.

.large[
**2. Attestations provide context, not just identity** 📝
]

Move beyond "it's signed" to "here's what happened."

.large[  
**3. Policy-based gating enables safe innovation** 🚀
]

Define requirements clearly, then give teams freedom to experiment.

.large[
**4. Start small, but think about the bigger picture** 🌟
]

Begin with one artifact, plan for your entire software supply chain.

]

---
name: last-page
template: inverse

## 🔗 Resources & Questions

**Red Hat Article**: [How we use software provenance at Red Hat](https://developers.redhat.com/articles/2025/05/15/how-we-use-software-provenance-red-hat)

**Try Konflux**: [konflux-ci.dev](https://konflux-ci.dev)

**SLSA Framework**: [slsa.dev](https://slsa.dev)

**in-toto Attestations**: [in-toto.io](https://in-toto.io)

---

name: inverse
layout: true
class: center, middle, inverse, title
---

# Questions? 

### 🛡️ Let's establish some trust! 

.footnote[Ralph Bean • @ralphbean • Red Hat] 