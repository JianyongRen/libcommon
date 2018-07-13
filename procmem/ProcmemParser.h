#ifndef __PROCMEM_PARSER_H__
#define __PROCMEM_PARSER_H__

#include <iostream>
#include <string>
#include <map>
#include <memory>

class ProcmemParser {
public:
	ProcmemParser():m_pid(-1) {};
	~ProcmemParser() {};

	int addLine(const std::string& line);
	int setTotal(const std::string& line);
	void setPid(int pid) { m_pid = pid; };
	void dump(std::ostream& os = std::cout);
private:
	struct ProcMemData {
		ProcMemData():Vss(0), Rss(0), Pss(0), Uss(0), ShCl(0), ShDi(0), PrCl(0), PrDi(0) {};
		int Vss;
		int Rss;
		int Pss;
		int Uss;
		int ShCl;
		int ShDi;
		int PrCl;
		int PrDi;
	};
	typedef std::map<std::string, std::shared_ptr<ProcMemData> > map_t;
	typedef std::pair<std::string, std::shared_ptr<ProcMemData> > pair_t;

	struct ComparePss {
		bool operator()(const pair_t& p1, const pair_t& p2);
	};

	bool parseLine(const std::string& line, ProcMemData& data, std::string& Name);
	void dumpData(const ProcMemData& data, const std::string& name, std::ostream& os);
	bool compare_pss(const pair_t& p1, const pair_t& p2);

	map_t m_proc_map;
	ProcMemData m_total;
	ProcMemData m_stack_xxx;
	int m_pid;
};



#endif

