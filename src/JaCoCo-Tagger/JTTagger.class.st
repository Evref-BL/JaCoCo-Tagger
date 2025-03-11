Class {
	#name : 'JTTagger',
	#superclass : 'Object',
	#instVars : [
		'famixModel',
		'sessionTag',
		'cacheFamixClassesByName',
		'cacheFamixMethodsByName'
	],
	#category : 'JaCoCo-Tagger',
	#package : 'JaCoCo-Tagger'
}

{ #category : 'api' }
JTTagger >> computeTagNameFrom: document [

	^ 'Story : '
	  , ((document nodes anyOne descendantNodesDetect: [ :node |
			    node name = 'sessioninfo' ]) attributeAt: #id)
]

{ #category : 'accessing' }
JTTagger >> famixClassesByName [

	^ cacheFamixClassesByName ifNil: [
		  cacheFamixClassesByName := (self famixModel allClasses collect: [
			                              :c | c mooseNameWithDots -> c. ])
			                             asOrderedCollection asDictionary ]
]

{ #category : 'accessing' }
JTTagger >> famixModel [

	^ famixModel
]

{ #category : 'accessing' }
JTTagger >> famixModel: anObject [

	famixModel := anObject
]

{ #category : 'api' }
JTTagger >> import: aFileReference [

	| document methods famixClass famixMethod tagName |
	document := (XMLDOMParser on: aFileReference readStream)
			            documentReadLimit: nil;
			            parseDocument.
			
	tagName := self computeTagNameFrom: document.
	sessionTag := famixModel tagNamed: tagName.

	methods := document nodes anyOne allNodesSelect: [ :node |
		           node name = 'method' ].

	methods do: [ :xmlMethod | "is the method at least partially covered"
		(xmlMethod nodes anySatisfy: [ :node |
			 (node attributeAt: #covered) asInteger > 0 ]) ifTrue: [
			| className methodName |
			className := xmlMethod parent attributeAt: #name.
			methodName := xmlMethod attributeAt: #name.
			famixClass := self searchFamixClassFromName: className.
			famixClass ifNotNil: [ sessionTag tagEntity: famixClass ].
			famixMethod := self searchFamixMethodsFromName: methodName.
			famixMethod ifNotNil: [ sessionTag tagEntity: famixMethod ] ] ]
]

{ #category : 'api' }
JTTagger >> importFromDirectory: aDirectoryPath [

	| fileReferences |
	fileReferences := (FileSystem disk workingDirectory / aDirectoryPath) children
		select: [ :each | each extension = 'xml' ].

	fileReferences do: [ :eachFile |
		self import: eachFile.
	].
]

{ #category : 'api' }
JTTagger >> searchFamixClassFromName: className [

	| standardClassName |
	standardClassName := className copyReplaceAll: '/' with: '.'.
	^ self famixClassesByName at: standardClassName ifAbsent: [nil].
	^ self famixModel allClasses
		  detect: [ :class | class mooseNameWithDots = standardClassName ]
		  ifNone: [ nil ]
]

{ #category : 'api' }
JTTagger >> searchFamixMethodsFromName: methodName [
	| standardMethodName |
	standardMethodName := methodName copyReplaceAll: '<' with: ''.
	standardMethodName := standardMethodName copyReplaceAll: '>' with: ''.
	
	^ self famixModel allMethods
		  detect: [ :c | c name = standardMethodName ]
		  ifFound: [ :c | c ]
		  ifNone: [ nil ]
]

{ #category : 'api' }
JTTagger >> searchFamixMethodsFromName: className and: methodName [

	^ self famixModel allClasses
		  detect: [ :c | c name = methodName ]
		  ifFound: [ :c | c ]
		  ifNone: [ nil ]
]
