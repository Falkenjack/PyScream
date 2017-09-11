from lxml import etree
from screamtypes_c import Document, Sentence, WordNode, FeatureVector

cpdef object parse_file(str filename, object swevoc, str classValue):
    cdef int sentenceCounter = 0
    cdef object currentDocument
    cdef object currentSentence
    cdef object xml_iterator
    currentDocument = Document(classValue, swevoc)
    currentDocument._filename = filename
    currentSentence = Sentence()

    xml_iterator = etree.iterparse(filename, events=["start","end"], encoding="UTF-8")
    for action, elem in xml_iterator:
        #print("%s: %s" % (action, elem.tag))
        if action == "start":
            if elem.tag == "w":
                continue
            elif elem.tag == "sentence":
                currentSentence = Sentence()
            elif elem.tag == "text":
                currentDocument._metadata = {k:v for k,v in elem.items()}
        elif action == "end":
            if elem.tag == "w":
                currentSentence.addWordNode(WordNode(elem))
            elif elem.tag == "sentence":
                currentSentence.finalize()
                currentDocument.addSentence(currentSentence)
                sentenceCounter += 1
            elif elem.tag == "text":
                currentDocument.finalize()
                #print(filename, "complete")
    return FeatureVector(currentDocument)

