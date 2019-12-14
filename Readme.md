# Sequence diagrams for pharo
*Last edited: 2019-12-14*

Sequence diagrams is a graphical UML diagram illustrating how objects interact.

Their primary strength is to show a timeline of how messages is passed between object, giving an overview of the role of each object, and which messages are passed between them.

This Pharo package is work in progress, and has three components:

* A bridge between the syntax of [PlantUML](https://plantuml.com), and Pharo. It allow you to compose the plant uml syntax in pharo, and get an image of the corresponding program. The core of the bridge is extracted from the work of [C. Fuhrman](https://github.com/fuhrmanator/PlantUMLPharoGizmo).
* A pillar language extension which allow plant uml diagrams to be inlined in in-image documentation. For this to work, you need the [in-image pillare render](https://github.com/kasperosterbye/PillarRichTextRender).
* A preliminary diagram generator. This tool will trace the execution of a Smalltalk block, and generate a sequence diagram for its execution. It is primarily intended as an investigation tool for discovering call backs and understanding the object interactions of existing software.
    
    The current version of the diagram generator is based on the build in `MessageTall` class.



