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

Our goals are to be able to:

Compose software that consists of **multiple components, from multiple repositories**.

Provide **transparency on the software supply chain**, including both what makes up the software and how it was built.

Provide a way for software teams to **release to destinations under the control other teams** (like SRE or release engineering teams).

Provide a **unified user experience** across the entire build, test, and release process

]
---
.left-column[
  ## What is it?
  ## Why use it?
]
.right-column[

If any of the following statements sound like you:

- You don't have a secure build environment today. Where do we even build?
 
- You worry about the **provenance** of your software builds.

- The build system you have today is **inflexible or difficult** to extend.

- You **get lost trying to follow the status** of artifacts on their way to release.

Then, Konflux might be the platform your team.
]
---
.left-column[
  ## What is it?
  ## Why use it?
]
.right-column[

As the Konflux build pipelines are engineered with security in mind:

- Builds produced by Konflux build-tasks are certain to have **accurate manifests**.
- Build dependencies are fetched up front and the build is executed with **no network available**.

As Konflux is based on Tekton:

- It provides **cryptographic attestation** about the provenance of the build, recorded as [in-toto](https://github.com/in-toto/attestation) attestations.
- This lets us write **machine-readable policy** which can be used at release time to determine if an artifact is acceptable.

As Konflux gates builds at release-time:

- Platform users can **develop new build strategies** in their production workspace to speed proofs of concept.

As Konflux is an integration of open source projects:

- Konflux must be flexible in its own architecture to permit **different deployment configurations**.

]
---
template: inverse

## What is the flow like, then?
---
name: how

.left-column[
  ## The Process
  ### - Build
]
.right-column[

Assume that your team has already used [the installer](https://github.com/konflux-ci/konflux-ci?tab=readme-ov-file#konflux-ci) to set up an instance or that somebody else is running an instance for you.

In the UI, you click, click..

TODO - Screenshot goes here.

Under the hood, the system has recorded an `Application` resource that represents a coherent set of Components that should be built, tested, and released together. It recorded a `Component` too, that represents the git branch on the git repository that should be used to build OCI artifacts from commits that appear there.
]
---
When you create the component, Konflux will send a **pull request** to your repo with the pipeline definition in a `.tekton/` directory.

![](pull-request.png)
---

```remark
apiVersion: tekton.dev/v1
kind: PipelineRun
spec:
  pipelineSpec:
    tasks:
    - name: build-container
      taskRef:
        params:
        - name: name
          value: buildah
        - name: bundle
          value: "quay.io/redhat-appstudio-tekton-catalog/task-buildah:0.1"
        - name: kind
          value: task
        resolver: bundles
      runAfter:
      - prefetch-dependencies
      workspaces:
      - name: source
        workspace: workspace
```

---
![](pull-request.png)
---
.left-column[
  ## The Process
  ### - Build
]
.right-column[

The pull request itself initiates a build in Konflux.


]
---
.left-column[
  ## The Process
  ### - Build
  ### - Test
]
.right-column[

You register integration tests with the system that should be executed against all of the components in your application in response to new builds.

TODO - example of a integration test calling out to testing farm

]
---
template: inverse

## Of course, Markdown can only go so far.
---
.left-column[
  ## Markdown extensions
]
.right-column[
To help out with slide layout and formatting, a few Markdown extensions have been included:

- Slide properties, for naming, styling and templating slides

- Content classes, for styling specific content

- Syntax highlighting, supporting a range of languages
]

---
.left-column[
  ## Markdown extensions
  ### - Slide properties
]
.right-column[
Initial lines containing key-value pairs are extracted as slide properties:

```remark
name: agenda
class: middle, center

# Agenda

The name of this slide is {{ name }}.
```

Slide properties serve multiple purposes:

* Naming and styling slides using properties `name` and `class`

* Using slides as templates using properties `template` and `layout`

* Expansion of `{{ property }}` expressions to property values

See the [complete list](https://github.com/gnab/remark/wiki/Markdown#slide-properties) of slide properties.
]
---
.left-column[
  ## Markdown extensions
  ### - Slide properties
  ### - Content classes
]
.right-column[
Any occurences of one or more dotted CSS class names followed by square brackets are replaced with the contents of the brackets with the specified classes applied:

```remark
.footnote[.red.bold[*] Important footnote]
```

Resulting HTML extract:

```xml
<span class="footnote">
  <span class="red bold">*</span> Important footnote
</span>
```
]
---
.left-column[
  ## Markdown extensions
  ### - Slide properties
  ### - Content classes
  ### - Syntax Highlighting
]
.right-column[
Code blocks can be syntax highlighted by specifying a language from the set of [supported languages](https://github.com/gnab/remark/wiki/Configuration#highlighting).

Using [GFM](http://github.github.com/github-flavored-markdown/) fenced code blocks you can easily specify highlighting language:

.pull-left[

<pre><code>```javascript
function add(a, b)
  return a + b
end
```</code></pre>
]
.pull-right[

<pre><code>```ruby
def add(a, b)
  a + b
end
```</code></pre>
]

A number of highlighting [styles](https://github.com/gnab/remark/wiki/Configuration#highlighting) are available, including several well-known themes from different editors and IDEs.

]
---
.left-column[
  ## Presenter mode
]
.right-column[
To help out with giving presentations, a presenter mode comprising the
following features is provided:

- Display of slide notes for the current slide, to help you remember
  key points

- Display of upcoming slide, to let you know what's coming

- Cloning of slideshow for viewing on extended display
]
---
.left-column[
  ## Presenter mode
  ### - Inline notes
]
.right-column[
Just like three dashes separate slides,
three question marks separate slide content from slide notes:

```
Slide 1 content

*???

Slide 1 notes

---

Slide 2 content

*???

Slide 2 notes
```

Slide notes are also treated as Markdown, and will be converted in the
same manner slide content is.

Pressing __P__ will toggle presenter mode.
]
???
Congratulations, you just toggled presenter mode!

Now press __P__ to toggle it back off.
---
.left-column[
  ## Presenter mode
  ### - Inline notes
  ### - Cloned view
]
.right-column[
Presenter mode of course makes no sense to the audience.

Creating a cloned view of your slideshow lets you:

- Move the cloned view to the extended display visible to the audience

- Put the original slideshow in presenter mode

- Navigate as usual, and the cloned view will automatically keep up with the original

Pressing __C__ will open a cloned view of the current slideshow in a new
browser window.
]
---
template: inverse

## It's time to get started!
---
.left-column[
  ## Getting started
]
.right-column[
Getting up and running is done in only a few steps:

1. Visit the [project site](http://github.com/gnab/remark)

2. Follow the steps in the Getting Started section

For more information on using remark, please check out the [wiki](https://github.com/gnab/remark/wiki) pages.
]
---
name: last-page
template: inverse

## That's all folks (for now)!

Slideshow created using [remark](http://github.com/gnab/remark).
