brat annotation configurations are currently controlled by text-based configuration files that can be created and edited in any text editor. This page documents the configuration language.

(Prefer to learn by example? Check out configurations for various projects in the configurations/ directory of your brat installation.)

**NOTE**: we are planning to introduce **GUI-based configuration** in a future release, but have so far focused development efforts on other aspects of the platform as the need to alter configurations arises comparatively rarely and the brat configuration language is simple enough to write even by non-experts.

## Table of contents

-   [Configuration basics](https://brat.nlplab.org/configuration.html#configuration-basics)
-   [Annotation configuration (annotation.conf)](https://brat.nlplab.org/configuration.html#annotation-configuration)
-   [Visual configuration (visual.conf)](https://brat.nlplab.org/configuration.html#visual-configuration)
-   [Tool configuration (tools.conf)](https://brat.nlplab.org/configuration.html#tool-configuration)
-   [Keyboard shortcut configuration (kb\_shortcuts.conf)](https://brat.nlplab.org/configuration.html#keyboard-configuration)
-   [Additional details](https://brat.nlplab.org/configuration.html#additional-details)

## Configuration basics

### Configuration files

the configuration of an annotation project is controlled by four files:

-   annotation.conf: annotation type configuration
-   visual.conf: annotation display configuration
-   tools.conf: annotation tool configuration
-   kb\_shortcuts.conf: keyboard shortcut tool configuration

Each annotation project typically defines its own annotation.conf. Defining visual.conf, tools.conf and kb\_shortcuts.conf is not necessary, and the system falls back on simple default visuals, tools and shortcuts if these files are not present.

The configuration files can be placed anywhere in the brat data directory, and are normally placed in the directory corresponding to the base directory of the collection they apply to. (To determine the configuration for a collection, the system searches up in the directory tree from the directory in which the collection data is toward the root of the brat data/ directory, falling back on default configurations if no configuration is present in any of these locations.)

### Configuration file structure

The configuration files follow a simple line-oriented structure and a syntax familiar from many other text-based configuration systems.

The top-level organization of the configuration files is into _sections_, each marked with a line containing only "\[section-name\]", where section-name is one of a set of predefined section names defined for the configuration file.

Within sections, each non-empty line defines one configuration item, where with the first non-space sequence names the item, and the rest of the line the specification, which varies by section.

Blank lines are ignored by the configuration reader. Similarly, lines beginning with the number sign "#" (also known as hash character) are ignored as comments.

An example of a simple annotation configuration file defining two entity and two relation types is shown below.

<table><tbody><tr><td>[entities]</td><td>&nbsp;</td></tr><tr><td>Person</td></tr><tr><td>Organization</td></tr><tr><td>&nbsp;</td></tr><tr><td>[relations]</td></tr><tr><td>Family</td><td>Arg1:Person, Arg2:Person</td></tr><tr><td>Employment</td><td>Arg1:Person, Arg2:Organization</td></tr><tr><td>&nbsp;</td></tr><tr><td colspan="2"># This is a comment line.</td></tr></tbody></table>

## Annotation configuration (annotation.conf)

The annotation configuration file, annotation.conf, is divided into the following sections:

-   \[entities\]
-   \[relations\]
-   \[events\]
-   \[attributes\]

Each of these sections must be present in the configuration file, but they can be empty. For example, a configuration can define only entity annotation targets by leaving the other three sections empty.

### Entity definitions (\[entities\] section)

The \[entities\] section defines the types for the things that can be marked in text as types text spans, such as mentions of real-world "things" such as people or locations.

The basic format of the \[entities\] section is a simple list, with one entity type per line. The following is an example of a simple \[entities\] section:

<table><tbody><tr><td>[entities]</td><td>&nbsp;</td></tr><tr><td>Person</td></tr><tr><td>Location</td></tr><tr><td>Organization</td></tr></tbody></table>

In addition to listing the entity types, the \[entities\] section can be used to define just one additional aspect of the annotation: the hierarchy in which the entities are organized. This is optional, and the syntax specifying a hierarchy of entity organization consists simply of TAB characters at the beginning of each line.

![](https://brat.nlplab.org/img/entity-type-hierarchy.png)

<table><tbody><tr><td>[entities]</td></tr><tr><td>Living-thing</td></tr><tr><td>&nbsp;</td><td>Person</td></tr><tr><td>&nbsp;</td><td>Animal</td></tr><tr><td>&nbsp;</td><td>Plant</td></tr><tr><td>Nonliving-thing</td></tr><tr><td>&nbsp;</td><td>Building</td></tr><tr><td>&nbsp;</td><td>Vehicle</td></tr></tbody></table>

Such a hierarchy is interpreted an an is-a taxonomy by the system.

The most immediately visible difference that defining an entity type hierarchy makes in annotation is that the type selector shows the hierarchy and allows parts of it to be collapsed (hidden) or opened to assist in navigating the available entity types. (This feature is primarily useful for larger numbers of defined types.)

For further information, see [advanced entity configuration](https://brat.nlplab.org/configuration.html#advanced-entities).

### Relation definitions (\[relations\] section)

The \[relations\] section defines binary relations between annotations. Relation annotations can mark, for example, a Family relationship between the entities identified by two Person annotations.

Each line in the \[relations\] section defines a relation type, the entities it can associate and, optionally, the properties of the relation. The types of annotations that can be associated by the relation are identified using the syntax ARG:TYPE (where ARG are, by convention, Arg1 and Arg2), separated by a comma.

The following example shows a simple \[relations\] section.

<table><tbody><tr><td>[relations]</td><td>&nbsp;</td></tr><tr><td>Family</td><td>Arg1:Person, Arg2:Person</td></tr><tr><td>Employment</td><td>Arg1:Person, Arg2:Organization</td></tr></tbody></table>

Relations can often take arguments of more than one type. This can be defined in the configuration by listing all the possible types separated by the pipe character "|". Cases where not all argument combinations are valid can be constrained by defining one valid set of combinations per line. These features are illustrated in the following example:

<table><tbody><tr><td>[relations]</td><td>&nbsp;</td><td>&nbsp;</td></tr><tr><td>Located</td><td>Arg1:Person,</td><td>Arg2:Building|City|Country</td></tr><tr><td>Located</td><td>Arg1:Building,</td><td>Arg2:City|Country</td></tr><tr><td>Located</td><td>Arg1:City,</td><td>Arg2:Country</td></tr></tbody></table>

As for entities, a hierarchy of relation types can be defined simply by placing TAB characters at the beginning of each line.

For further information on relation definitions, see [advanced relation configuration](https://brat.nlplab.org/configuration.html#advanced-relations).

### Event definitions (\[events\] section)

The \[events\] section defines _n_\-ary associations between other annotations (entities or events). The "event" category of annotations can be used to mark things that are stated to happen in text, such as two people getting married or a company going bankrupt.

The basic syntax for defining events is similar to that for relations. Each lines defined one event type (or, more specifically, one event "frame" — possible combination of arguments), with the event arguments specified with a ROLE:TYPE syntax and separated by commas. The roles that event participants play in an event (ROLE) in the definition can be freely defined.

The following example shows a simple \[events\] section.

<table><tbody><tr><td>[events]</td><td>&nbsp;</td></tr><tr><td>Marriage</td><td>Participant1:Person, Participant2:Person</td></tr><tr><td>Bankruptcy</td><td>Org:Company</td></tr></tbody></table>

### Attribute definitions (\[attributes\] section)

The \[attributes\] section defines binary or multi-valued "flags" that can be used to mark other annotations. For example, a Negated attribute could be used to mark the occurrence of an annotated event as being explicitly denied in text, or a Confidence attribute to mark an event as one of Certain, Probable or Doubtful.

Each line in the \[attributes\] section defines an attribute type and the annotations it can attach to. For binary attributes, the possible values, true and false, are implicit; for multi-valued attributes, the possible values must also be specified.

The annotation type (or types) an attribute can apply to are defined using the ARG:TYPE syntax used also in the definition of relations and events (ARG is, by convention, "Arg"). The values a multi-valued attribute can take are defined using the syntax Value:VAL1|VAL2|VAL3\[...\], where "Value" is a literal string and VAL1, VAL2 etc. are the possible values.

The following example shows a simple \[attributes\] section.

<table><tbody><tr><td>[attributes]</td><td>&nbsp;</td></tr><tr><td>Negated</td><td>Arg:&lt;EVENT&gt;</td></tr><tr><td>Confidence</td><td>Arg:&lt;EVENT&gt;, Value:L1|L2|L3</td></tr></tbody></table>

For further information on configuring the visual display of attributes, see [advanced attribute configuration](https://brat.nlplab.org/configuration.html#advanced-attributes).

## Visual configuration (visual.conf)

The visual configuration file, visual.conf, is divided into the following sections:

-   \[labels\]
-   \[drawing\]

Each of these sections must be present in the configuration file, but they can be empty.

### Label definitions (\[labels\] section)

The \[labels\] section defines the labels to use in the display of the defined annotation types on the user interface. If no labels are defined for a type, the system defaults do displaying the configured type as defined in annotation.conf.

The definition of labels has two primary uses: allowing labels used in the user interface to use arbitrary characters (see the section on [type names](https://brat.nlplab.org/configuration.html#type-names)), and defining abbreviations to use when there is limited space in the layout.

The format of the \[labels\] section is simple: each line contains a set of strings, separated by pipe characters ("|"). The first string should correspond to a type defined in annotation.conf; the second is taken to be the preferred, full form to use for the type, and the remaining (if any) should correspond to its progressively shorter abbreviations.

The following example shows a simple \[labels\] section.

<table><tbody><tr><td>[labels]</td></tr><tr><td>Organization | Organization | Org</td></tr><tr><td>Immaterial-thing | Immaterial thing | Immaterial | Immat</td></tr></tbody></table>

Note that the first and second strings will be identical in cases where the type as defined in annotation.conf matches the preferred way of displaying it. Also, space is permitted in labels, and space surrounding labels is ignored.

### Drawing configuration (\[drawing\] section)

The \[drawing\] section defines various non-textual aspects of the visual presentation. If no visual configuration is defined for a type, the system uses default settings, which can themselves be configured.

The format of the \[drawing\] section is similar to that used in the other configurations. Each line contains the type of the annotation that the visual configuration applies to, and a set of KEY:VALUE pairs specifying the visual settings.

The following example shows a simple \[drawing\] section.

<table><tbody><tr><td>[drawing]</td><td>&nbsp;</td></tr><tr><td>Person</td><td>bgColor:#ffccaa</td></tr><tr><td>Family</td><td>fgColor:darkgreen, arrowHead:triangle-5</td></tr></tbody></table>

This example specifies that annotations of the Person type should be drawn with background of the color #ffccaa, and that arcs representing Family relations should be drawn with dark green lines ending with 5-pixel triangular arrowheads.

The recognized visual configuration keys, their values, and purpose are

-   fgColor: any [HTML color](http://www.w3schools.com/html/html_colors.asp) specification (e.g. "black"), sets the color of a span text in the visualization.
-   bgColor: any HTML color specification (e.g. "white"), sets the color of a span "box" background in the visualization.
-   borderColor: any HTML color specification (e.g. "black"), sets the color of a span "box" border in the visualization. Also supports special value "darken", which specifies to use a darker shade of bgColor for the border.
-   color: any HTML color specification (e.g. "black"), sets the color of an arc in the visualization.
-   dashArray: any valid [SVG stroke-dasharray](http://www.w3.org/TR/SVG/painting.html#StrokeDasharrayProperty) specification using dashes (instead of commas or space) as separators (e.g. "3-3"), sets the dash/dot pattern for lines in the span/arc visualization ("-" works for solid line)

The special labels "SPAN\_DEFAULT" and "ARC\_DEFAULT" are recognized as setting defaults that will be used for types without specific settings. It is not necessary to define all aspects of the visualization (e.g. just Color can be given): defaults will be used for unspecified cases. The following example illustrates the use of these defaults.

<table><tbody><tr><td>[drawing]</td><td>&nbsp;</td></tr><tr><td>SPAN_DEFAULT</td><td>fgColor:black, bgColor:lightgreen, borderColor:darken</td></tr><tr><td>ARC_DEFAULT</td><td>color:black, dashArray:-, arrowHead:triangle-5</td></tr><tr><td>Person</td><td>bgColor:#ffccaa</td></tr><tr><td>Family</td><td>fgColor:darkgreen</td></tr></tbody></table>

In this configuration, all annotation types except Person and Family will be draws using the specified default values. Further Person and Family annotations will also "inherit" the defaults for aspect of the visual presentation that are not explicitly defined, so that e.g. for the borderColor of Person annotations, the system, will use the special value darken.

The annotation tool configuration file, tools.conf, is divided into the following sections:

-   \[options\]
-   \[search\]
-   \[normalization\]
-   \[annotators\]
-   \[disambiguators\]

These sections are all optional: an empty file is a valid tools.conf.

### Option configuration (\[options\] section)

**Note:** the \[options\] section is supported since v1.3 (Crunchy Frog). See the page on [upgrading to v1.3 (Crunchy Frog)](https://brat.nlplab.org/upgrading-to-v1.3.html) for information on how these options relate to settings in earlier versions.

The \[options\] section can be used to set how the brat server performs sentence segmentation (splitting), tokenization, annotation validation, and logging, as follows:

-   `Tokens tokenizer:VALUE`, where `VALUE`\=
    -   `whitespace`: split by whitespace characters in source text (only)
    -   `ptblike`: emulate Penn Treebank tokenization
    -   `mecab`: perform Japanese tokenization using MeCab
-   `Sentences splitter:VALUE`, where `VALUE`\=
    -   `regex`: regular expression-based sentence splitting
    -   `newline`: split by newline characters in source text (only)
-   `Validation validate:VALUE`, where `VALUE`\=
    -   `all`: perform full validation
    -   `none`: don't perform any validation
-   `Annotation-log logfile:VALUE`, where `VALUE`\=
    -   `<NONE>`: no annotation logging
    -   `NAME`: log into file NAME (e.g. "/home/brat/work/annotation.log")

For example, the following \[options\] section gives the default brat configuration before v1.3:

<table><tbody><tr><td>[options]</td><td>&nbsp;</td></tr><tr><td>Tokens</td><td>tokenizer:whitespace</td></tr><tr><td>Sentences</td><td>splitter:regex</td></tr><tr><td>Validation</td><td>validate:none</td></tr><tr><td>Annotation-log</td><td>logfile:&lt;NONE&gt;</td></tr></tbody></table>

The following \[options\] section enables Japanese tokenization using MeCab, sentence splitting only by newlines, full validation, and annotation logging into the given file. (In setting `Annotation-log logfile`, remember to make sure the web server has appropriate write permissions to the file.)

<table><tbody><tr><td>[options]</td><td>&nbsp;</td></tr><tr><td>Tokens</td><td>tokenizer:mecab</td></tr><tr><td>Sentences</td><td>splitter:newline</td></tr><tr><td>Validation</td><td>validate:all</td></tr><tr><td>Annotation-log</td><td>logfile:/home/brat/work/annotation.log</td></tr></tbody></table>

### Normalization DB configuration (\[normalization\] section)

The \[normalization\] section defines the normalization resources that are available. For information on setting up normalization DBs, see the [brat normalization documentation](https://brat.nlplab.org/normalization.html).

Each line in the \[normalization\] section has the following syntax:

```
    DBNAME     DB:DBPATH, &lt;URL&gt;:HOMEURL, &lt;URLBASE&gt;:ENTRYURL
```

Here, `DB`, `<URL>`, `<URLBASE>` and `<PATH>` are literal strings (they should appear as written here), while "DBNAME", "DBPATH", "HOMEURL" and "ENTRYURL" should be replaced with specific values appropriate for the database being configured:

-   `DBNAME`: sets the database name (e.g. "Wiki", "GO"). The name can be otherwise freely selected, but should not contain characters other than alphanumeric ("a"-"z", "A"-"Z", "0"-"9"), hyphen ("-") and underscore ("\_"). This name will be used both in the brat UI and in the [annotation file](https://brat.nlplab.org/configuration.html#norm-standoff) to identify the DB.
-   `DBPATH` (optional): provides the file system path to the normalization DB data on the server, relative to the brat server root. If `DBPATH` isn't set, the system assumes the DB can be found in the default location under the given `DBNAME`.
-   `HOMEURL`: sets the URL for the home page of the normalization resource (e.g. "http://en.wikipedia.org/wiki/"). Used both to identify the resource more specifically than `DBNAME` and to provide a link in the [annotation UI](https://brat.nlplab.org/configuration.html#norm-annotation) for accessing the resource.
-   `URLBASE` (optional): sets a URL template (e.g. "http://en.wikipedia.org/?curid=%s") that can be filled in to generate a direct link in the [annotation UI](https://brat.nlplab.org/configuration.html#norm-annotation) to an entry in the normalization resource. The value should contain the characters "%s" as a placeholder that will be replaced with the ID of the entry.

The following example shows examples of configured normalization DBs.

<table><tbody><tr><td>[normalization]</td><td>&nbsp;</td></tr><tr><td>Wiki</td><td>DB:dbs/wiki, &lt;URL&gt;:http://en.wikipedia.org, &lt;URLBASE&gt;:http://en.wikipedia.org/?curid=%s</td></tr><tr><td>UniProt</td><td>&lt;URL&gt;:http://www.uniprot.org/, &lt;URLBASE&gt;:http://www.uniprot.org/uniprot/%s</td></tr></tbody></table>

The first line sets configuration for a database called "Wiki", found as "dbs/wiki" in the brat server directory, and the second for a DB called "UniProt", found in the default location for a DB with this name.

### Search configuration (\[search\] section)

The \[search\] section defines the online search services that are made available in the annotation dialog.

![](https://brat.nlplab.org/img/search-config-1.png)

Each line in the \[search\] section contains the name used in the user interface for the search service, and a single key:value pair. The key should have the special value "<URL>" and its value should be the URL URL of the search service with the string to query for replaced by "%s".

The following example shows a simple \[search\] section.

<table><tbody><tr><td>[search]</td><td>&nbsp;</td></tr><tr><td>Google</td><td>&lt;URL&gt;:http://www.google.com/search?q=%s</td></tr><tr><td>Wikipedia</td><td>&lt;URL&gt;:http://en.wikipedia.org/wiki/%s</td></tr></tbody></table>

When selecting a span or editing an annotation, these search options will then be shown in the brat annotation dialog.

### Annotation tool configuration (\[annotators\] section)

The \[annotators\] section defines automatic annotation services that can be invoked from brat.

Each line in the \[annotators\] section contains a unique name for the service and key:value pairs defining the way it is presented in the user interface and the URL of the web service for the tool. Values should be given for "tool", "model" and "<URL>" (the first two are used for the user interface only).

The following example shows a simple \[annotators\] section.

<table><tbody><tr><td>[annotators]</td><td>&nbsp;</td></tr><tr><td>SNER-CoNLL</td><td>tool:Stanford_NER, model:CoNLL, &lt;URL&gt;:http://example.com:80/tagger/</td></tr></tbody></table>

### Disambiguation tool configuration (\[disambiguators\] section)

The \[disambiguators\] section defines automatic semantic class (annotation type) disambiguation services that can be invoked from brat.

Each line in the \[disambiguators\] section contains a unique name for the service and key:value pairs defining the way it is presented in the user interface and the URL of the web service for the tool. Values should be given for "tool", "model" and "<URL>" (the first two are used for the user interface only).

The following example shows a simple \[disambiguators\] section.

<table><tbody><tr><td>[disambiguators]</td><td>&nbsp;</td></tr><tr><td>simsem-MUC</td><td>tool:simsem, model:MUC, &lt;URL&gt;:http://example.com:80/simsem/%s</td></tr></tbody></table>

As for search, the string to query for is identified by "%s" in the URL.

## Keyboard shortcut configuration (kb\_shortcuts.conf)

The keyboard shortcut configuration file, kb\_shortcuts.conf, contains no section structure and has a very simple syntax: each line contains a single character and an annotation type, specifying that the key for the given character should be used as a shortcut for selecting the given type. For example:

<table><tbody><tr><td>P</td><td>Person</td></tr><tr><td>O</td><td>Organization</td></tr><tr><td>F</td><td>Family</td></tr></tbody></table>

These shortcuts can then be used in the appropriate annotation dialogs to rapidly select the associated type.

**Hint**: well-configured keyboard shortcuts can speed up simple annotation tasks a lot in particular when used with the _Normal_ and _Rapid_ annotation modes, which can be selected from the _Options_ menu in the brat UI.

## Additional details

### Advanced entity configuration

**Disabled entries**: entries in the entity selection dialog can be disabled by adding an exclamation mark ("!") before the type name in the \[entities\] section. The type will appear in the type hierarchy for structure, but cannot itself be selected. For example:

<table><tbody><tr><td>[entities]</td></tr><tr><td>!Living-thing</td></tr><tr><td>&nbsp;</td><td>Person</td></tr><tr><td>&nbsp;</td><td>Animal</td></tr><tr><td>&nbsp;</td><td>Plant</td></tr><tr><td>!Nonliving-thing</td></tr><tr><td>&nbsp;</td><td>Building</td></tr><tr><td>&nbsp;</td><td>Vehicle</td></tr></tbody></table>

The above \[entities\] section defines Living-thing and Nonliving-thing as part of the is-a hierarchy, but does not make the types available for use in annotation.

### Advanced relation configuration

Relation definitions support the ability to set relation properties through the special attribute <REL-TYPE> as shown in the following example.

<table><tbody><tr><td>[relations]</td><td>&nbsp;</td></tr><tr><td>Equiv</td><td>Arg1:Person, Arg2:Person, &lt;REL-TYPE&gt;:symmetric-transitive</td></tr></tbody></table>

The <REL-TYPE> specification currently supports two properties, symmetric and transitive, which can apply either separately or together. Multiple properties can be combined by using the dash character ("\-"), as in the above example.

The combination symmetric-transitive defines an _equivalence relation_.

The \[relations\] section is also used to define rules regarding which entities are allowed to overlap in their spans (checked in annotation validation). The syntax for defining this feature is the following (supported since v1.3):

<table><tbody><tr><td>[relations]</td><td>&nbsp;</td></tr><tr><td>&lt;OVERLAP&gt;</td><td>Arg1:TYPE1, Arg2:TYPE2, &lt;OVL-TYPE&gt;:TYPE-SPEC</td></tr></tbody></table>

i.e. standard relation configuration syntax with the type <OVERLAP> and the additional special attribute <OVL-TYPE>. The TYPE-SPEC can have any of the values contain, equal or cross, interpreted as follows:

-   contain: TYPE1 entity spans may be contained (fully) inside the spans of TYPE2 entities
-   equal: the spans of TYPE1 and TYPE2 entities may be equal
-   cross: the spans of TYPE1 and TYPE2 entities may cross

contain, equal and cross can be combined by the "|" character to express e.g. equal|cross for "may be equal or cross", and the value <ANY> can be used to express that any overlap is allowed.

Any entity overlap not specifically allowed in an <OVERLAP> setting is assumed by the annotation validation to be an error.

A few example <OVERLAP> relation definitions are shown in the following:

<table><tbody><tr><td>&lt;OVERLAP&gt;</td><td>Arg1:Country, Arg2:Organization, &lt;OVL-TYPE&gt;:contain</td></tr><tr><td>&lt;OVERLAP&gt;</td><td>Arg1:Person, Arg2:Person, &lt;OVL-TYPE&gt;:equal</td></tr><tr><td>&lt;OVERLAP&gt;</td><td>Arg1:&lt;ENTITY&gt;, Arg2:&lt;ENTITY&gt;, &lt;OVL-TYPE&gt;:&lt;ANY&gt;</td></tr></tbody></table>

These are interpreted, respectively, as "a Contry annotation can be contained in an Organization annotation" (e.g. \[Bank of \[England\]\]), "Person annotations can have identical spans" (e.g. \[\[the Johnsons\]\]), and "any entity annotation may overlap in any way with any other" (see below for the <ENTITY> shortcut definition).

### Advanced attribute configuration

Multi-valued attributes can be defined using the syntax illustrated in the following example (annotation.conf):

<table><tbody><tr><td>[attributes]</td><td>&nbsp;</td></tr><tr><td>Confidence</td><td>Arg:&lt;EVENT&gt;, Value:L1|L2|L3</td></tr></tbody></table>

The visual configuration of multi-valued attributes in visual.conf can then specified as in one of the following examples:

<table><tbody><tr><td>[drawing]</td><td>&nbsp;</td></tr><tr><td>Confidence</td><td>glyph:(1)|(2)|(3), position:left</td></tr></tbody></table>

or

<table><tbody><tr><td>[drawing]</td><td>&nbsp;</td></tr><tr><td>Confidence</td><td>dashArray:-|3-3|3-6</td></tr></tbody></table>

### Shortcuts and macros

The following "shortcuts" are defined for convenience for annotation.conf definitions:

-   <ENTITY>: any entity type (any type appearing in the \[entities\] section)
-   <RELATION>: any relation type (any type appearing in the \[relations\] section)
-   <EVENT>: any event type (any type appearing in the \[events\] section)
-   <ANY>: any type

These shortcuts can be used in definitions as in the following partial annotation.conf example:

<table><tbody><tr><td>[events]</td><td>&nbsp;</td></tr><tr><td>Transport</td><td>Theme:&lt;ENTITY&gt;, Cause:&lt;ANY&gt;</td></tr><tr><td>&nbsp;</td></tr><tr><td>[attributes]</td></tr><tr><td>Speculation</td><td>Arg:&lt;EVENT&gt;</td></tr><tr><td>Name</td><td>Arg:&lt;ENTITY&gt;</td></tr></tbody></table>

Here, Transport events, for example, take a Theme which is any entity type and a Cause of any type.

The configuration files additionally support a syntax for defining arbitrary "macros", as illustrated in the following:

<LIVING-THING>=Person|Animal|Plant

Defined macros can then appear anywhere in the configuration, and will be interpreted using simple textual replacement; any occurrence of a string defined as a macro (e.g. "<LIVING-THING>") in a configuration file will be processed as if its value (e.g. "Person|Animal|Plant") were written in its place.

These shortcuts can make configurations with many types more concise and easier to read and write.

### Type names

Each annotation type consists of one or more characters, constrained to the set of alphanumeric characters ("a"-"z", "A"-"Z", "0"-"9"), the hyphen ("-") and the underscore ("\_") character.

However, these restrictions apply only to annotation.conf, which defines the types used by the system internally and in storage on disk. The corresponding labels appearing on the user interface, defined in visual.conf, have no such limitations, and can contain, for example, space or arbitrary Unicode characters.

Additionally, the special value <EMPTY> can be used in visual.conf to specify that a label or similar marker such as an attribute glyph the should not be shown.

The following (partial) configuration examples illustrate arbitrary characters in labels on the user interface.

annotation.conf:

![](https://brat.nlplab.org/img/nonascii-label-example.png)

<table><tbody><tr><td>[entities]</td></tr><tr><td>Immaterial-thing</td></tr><tr><td>Organization</td></tr><tr><td># (rest of config omitted)</td></tr></tbody></table>

visual.conf:

<table><tbody><tr><td>[labels]</td></tr><tr><td>Immaterial-thing | Immaterial thing</td></tr><tr><td>Organization | 組織</td></tr><tr><td># (rest of config omitted)</td></tr></tbody></table>