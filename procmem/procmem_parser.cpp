#include <iostream>
#include <string>
#include <fstream>

#include "ProcmemParser.h"

using namespace std;

int main(int argc, char* argv[])
{
	bool output_cout = true;
	bool input_cin = true;
	std::ifstream ifs;
	std::ofstream ofs;
	if( argc >= 3 ) {
		output_cout = false;
		ofs.open(argv[2], std::ofstream::out | std::ofstream::trunc);
		if( !ofs.is_open() ) {
			cerr << "open " << argv[2] << " failed\n";
			return -1;
		}
	}
	if( argc >= 2 ) {
		input_cin = false;
		ifs.open(argv[1]);
		if( !ifs.is_open() ) {
			cerr << "open " << argv[1] << " failed\n";
			return -1;
		}
	}


	int stat = 0;
	string line;
	ProcmemParser* parser = nullptr;
	while( true ) {
		if( input_cin ) {
			//printf("[rjy] (%s:%d)\n",__func__,__LINE__);
			if( !getline(std::cin, line) ) {
				break;
			}
		} else {
			//printf("[rjy] (%s:%d)\n",__func__,__LINE__);
			if( !getline(ifs, line) ) {
				break;
			}
		}
		if( parser == nullptr ) {
			parser = new ProcmemParser();
		}

		if( line.compare(0, 6, "------") == 0 ) {
			stat++;
			continue;
		} else if( line.compare(0, 7, "pid is ") == 0 ) {
			const char* p = line.c_str() + 7;
			parser->setPid(atoi(p));
			continue;
		}

		if( stat == 1 ) {
			parser->addLine(line);
		} else if( stat == 2 ) {
			parser->setTotal(line);
			stat = 0;
			if( output_cout ) {
				parser->dump();
			} else {
				parser->dump(ofs);
			}
			delete parser;
			parser = nullptr;
		}
	}

	if( parser ) {
		delete parser;
	}

	return 0;
}

