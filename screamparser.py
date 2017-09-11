from lxml import etree
from screamtypes import Document, Sentence, WordNode, FeatureVector

def parse_file(filename, swevoc, classValue = 'normal'):
    sentenceCounter = 0
    currentDocument = Document(classValue, swevoc)
    currentDocument._filename = filename
    currentSentence = Sentence()
    
    def handleWord(elem):
#        currentWord = WordNode(elem.text,
#                               elem.get("pos"),
#                               elem.get("lemma").replace('|', ''),
#                               elem.get("deprel"),
#                               elem.get("ref"),
#                               elem.get("dephead"))
        currentSentence.addWordNode(WordNode(elem))#, etree.tostring(elem))
        #print(etree.tostring(elem))
            
    def handleSentence():
        currentSentence.finalize()
#        currentDocument.addSentence(currentSentence)
        currentDocument.addSentence(currentSentence)
    
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
                handleWord(elem)
            elif elem.tag == "sentence":
                handleSentence()
                sentenceCounter += 1
            elif elem.tag == "text":
                currentDocument.finalize()
                #print(filename, "complete")
    return FeatureVector(currentDocument)

