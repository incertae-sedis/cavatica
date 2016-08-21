#include <cstring>       	// size_t
#include <cstdio>        	// FILE
#include <iostream>      	// cout
#include <cstdlib>       	// malloc
#include <string>
#include "pugixml.hpp"

/*
size_t GetFileSize(FILE* input){
  fseek(input, 0, SEEK_END);    // Move reader to end of file
#ifdef _WIN64
  size_t size=_ftelli64(input); // Windows 64
#else
  size_t size=ftell(input);     // All Other Operating Systems
#endif
  rewind(input);                // Move reader to beginning of file
  return size;
}
unsigned char* LoadFile(char* filename, size_t& size) throw(std::string){
  FILE *input=fopen(filename, "rb");     // read in as binary
  std::string except=filename;           // exception message, runtime error handling
  if(input==NULL){
	except.append("No such file: "); throw except;
  }
  size=GetFileSize(input);               // Get number of characters in file
  if(size<=0){
	except.append("Empty File or problem opening file");
	fclose(input); throw except;
  }
  // Allocate memory
  unsigned char* str = (unsigned char*)malloc(size*sizeof(unsigned char));
  size_t tt=fread(str, sizeof(char), size, input);  
  fclose(input);                          // close file
  if(tt!=size){
	std::string except="Not reading file completely.";
	free(str); throw except;
  }
  return str;
}

void PrintStr(unsigned char* str, size_t size){
    for(int i=0 ;i<size; i++){
        if(str[i]=='\0'){               // Treat '\0' characters as new line characters
            std::cout<<std::endl;
        }else {
            std::cout<<str[i];          // print out each character separated by a ‘|’ character
            std::cout<<'|';
        }
    }
    std::cout<<std::endl;               // Put in a final new line in case
}
*/

int main(int argc, char* argv[]){
  if(argc<2){
    printf("Not enough arguments!\n");
    exit(1);
  }

  char* filename=argv[1];
  /*
  size_t size;
  unsigned char* str;
  str=LoadFile(filename,size);
  */
  
  pugi::xml_document doc;
  pugi::xml_parse_result result = doc.load_file(filename);
  if(!result){ // if unsuccessful at loading XML file
    printf("XML [%s] parsed with errors",filename);
    printf("Error description: %s",result.description());
    //    st->SetLabel("Status: XML file corrupted. Can't parse.");
    exit(1);
  }

  for(pugi::xml_node article=doc.child("pmc-articleset").child("article");
      article;
      article=article.next_sibling("article")){
    // Article type
    printf("%s",article.attribute("article-type").value());

    printf("\t");
    // Pubmed ID
    for(pugi::xml_node id=article.child("front").child("article-meta").child("article-id");
	id;
	id=id.next_sibling("article-id")){
      if(strcmp(id.attribute("pub-id-type").value(),"pmid")==0){
	printf("%s",id.child_value());
	//	std::cout<<"\t"<<id.child_value();
      }
    }

    // Article Title
    std::string ss=article.child("front").child("article-meta").child("title-group").child("article-title").child_value();
    ss.erase(std::remove(ss.begin(),ss.end(),'\n'),ss.end());
    printf("\t %s",ss.c_str());
    
    printf("\n");
    
    // Body
    /*
    for(pugi::xml_node p=article.child("body").child("p");
	p;
	p=p.next_sibling("p")){
      std::cout<<"\nPara:"<<p.child_value();
    }
    */
  }
}
