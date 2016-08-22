#include <cstring>       	// size_t
#include <cstdio>        	// FILE
#include <iostream>      	// cout
#include <cstdlib>       	// malloc
#include <string>
#include <vector>
#include "pugixml.hpp"

/* recursive function */
std::vector<std::string> loc;

void pcomplex(pugi::xml_node p){
  for(pugi::xml_node child: p.children()){
    printf("VAL=%s\n\n",child.child_value());
  }
}

void PrintParagraph(pugi::xml_node node, std::vector<std::string> l){
  /*
  printf("PrintParagraph loc.size=%li loc:",loc.size());
  for(int i=0; i<loc.size(); i++){
    printf("%s ",loc[i].c_str());
  }
  printf("\n");
  */
  
  std::string cc;
  std::string temp="";
  if(loc.size()>0){
    temp=loc[loc.size()-1];
  }
  for(pugi::xml_node child : node.children()){
    cc=child.name();
    
    //printf("\t%s|%s -> %s\n",temp.c_str(),node.name(),cc.c_str());
    if((strcmp(cc.c_str(),"p"))!=0){
      /*
      if((strcmp(cc.c_str(),"title"))==0){
	cc=cc+":"+(child.child_value());
      }
      */
      if((strcmp(cc.c_str(),"sec"))==0){
	cc=cc+":"+(child.attribute("disp-level").value())+":"+child.child("title").child_value();
      }
      loc.push_back(cc);
      //printf("Push %s\n",cc.c_str());
      PrintParagraph(child,loc);
      loc.pop_back();

      //printf("Pop \n");
    }else{
      printf("LOC: ");
      for(int i=0; i<loc.size(); i++){
	printf("%s |",loc[i].c_str());
      }
      printf("\n");
      printf("PARA: %s\n\n",child.child_value());
      //      pcomplex(child);
    }
    
  }
}

/*
void FindNextParagraph(pugi::xml_node node,std::vector<std::string>& loc){
  int ii=0; 
  for(pugi::xml_node child : node.children()){
    ii++;
    std::string cc=child.name();
    
    printf("%i child name |%s| %li\n",ii, cc.c_str(),loc.size());
    
    if(strcmp(cc.c_str(),"p")==0){
      printf("found p %li\n",loc.size());
      printf("\nLOC:");
      for(int i=0; i<loc.size(); i++){
	printf("%s |",loc[i].c_str());
      }
      printf("\nPARA:%s\n",child.child_value());
    }else{
      printf("not p %li, clen=%li\n",loc.size(),cc.length());
      if(cc.length()==0){
	printf("ZERO!!\n");
	return;
      }else{
	printf("not zero\n");
      }
      
      if(strcmp(cc.c_str(),"sec")==0){
	cc=cc+":"+(child.attribute("disp-level").value());
      }else{
	if(strcmp(cc.c_str(),"title")==0){
	  cc=cc+":"+(child.child_value());
	}
      }
      
      if(cc.length()>0){
	loc.push_back(cc);
	printf("push here\n");
	printf("%s %li\n",cc.c_str(),loc.size());
	FindNextParagraph(child,loc);
	if(loc.size()>0){
	  //    loc.push_back("hi");
	  loc.pop_back();
	  printf("%i pop here\n", ii);
	}
	//	if(loc.size()>0) loc.pop_back();
      }
      
    }
  }

}
*/

int main(int argc, char* argv[]){
  if(argc<2){
    printf("Not enough arguments!\n");
    exit(1);
  }

  char* filename=argv[1];
  
  pugi::xml_document doc;
  pugi::xml_parse_result result = doc.load_file(filename);
  if(!result){ // if unsuccessful at loading XML file
    printf("XML [%s] parsed with errors",filename);
    printf("Error description: %s",result.description());
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
      }
    }

    // Article Title
    std::string ss=article.child("front").child("article-meta").child("title-group").child("article-title").child_value();
    std::string::size_type pos=0;
    while((pos=ss.find("\n",pos))!=std::string::npos){
      ss[pos]=' ';
    }
    //    ss.erase(std::remove(ss.begin(),ss.end(),'\n'),ss.end());
    printf("\t %s",ss.c_str());
    
    // Body
    /*
    for(pugi::xml_node p=article.child("body").child("p");
	p;
	p=p.next_sibling("p")){
      printf("\nPara: %s",p.child_value());
    }
    printf("\n===\n\n");
    */

    printf("\n");
    // Can I find out children?
    std::vector<std::string> ll;
    loc.clear();
    PrintParagraph(article.child("body"),loc);
    //    FindNextParagraph(article.child("body"),loc);
    printf("\n===\n\n");
  }
}
