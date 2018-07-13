#include <stdio.h>
#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <algorithm>
#include <functional>

#include "ProcmemParser.h"

bool ProcmemParser::parseLine(const std::string& line, ProcMemData& data, std::string& Name)
{
	std::stringstream ssin(line);

	//Vss      Rss      Pss      Uss     ShCl     ShDi     PrCl     PrDi  Name
	ssin >> data.Vss;
	if( data.Vss == 0 ) {
		return false;
	}

	ssin.ignore(8,' ');
	ssin >> data.Rss;
	ssin.ignore(8,' ');
	ssin >> data.Pss;
	ssin.ignore(8,' ');
	ssin >> data.Uss;
	ssin.ignore(8,' ');
	ssin >> data.ShCl;
	ssin.ignore(8,' ');
	ssin >> data.ShDi;
	ssin.ignore(8,' ');
	ssin >> data.PrCl;
	ssin.ignore(8,' ');
	ssin >> data.PrDi;
	ssin.ignore(8,' ');
	ssin >> Name;

	return true;
}

int ProcmemParser::addLine(const std::string& line)
{
	std::string name;
	std::shared_ptr<ProcMemData> data(new ProcMemData);
	map_t::iterator it;

	if( parseLine(line, *(data.get()), name) == false ) {
		return -1;
	}

	//dumpData(*(data.get()), name);
	if( !name.empty() && name.compare(0, 7, "[stack:") == 0 ) {
		m_stack_xxx.Vss += data->Vss;
		m_stack_xxx.Rss += data->Rss;
		m_stack_xxx.Pss += data->Pss;
		m_stack_xxx.Uss += data->Uss;
		m_stack_xxx.ShCl += data->ShCl;
		m_stack_xxx.ShDi += data->ShDi;
		m_stack_xxx.PrCl += data->PrCl;
		m_stack_xxx.PrDi += data->PrDi;
	}

	it = m_proc_map.find(name);
	if( it == m_proc_map.end() ) {
		m_proc_map.insert(map_t::value_type(name, data));
	} else {
		it->second->Vss += data->Vss;
		it->second->Rss += data->Rss;
		it->second->Pss += data->Pss;
		it->second->Uss += data->Uss;
		it->second->ShCl += data->ShCl;
		it->second->ShDi += data->ShDi;
		it->second->PrCl += data->PrCl;
		it->second->PrDi += data->PrDi;
	}

	return 0;
}

void ProcmemParser::dumpData(const ProcMemData& data, const std::string& name, std::ostream& os)
{
	char buf[2048] = {0};
	snprintf(buf, sizeof(buf), "%8dK%8dK%8dK%8dK%8dK%8dK%8dK%8dK %s\n", 
			data.Vss,
			data.Rss,
			data.Pss,
			data.Uss,
			data.ShCl,
			data.ShDi,
			data.PrCl,
			data.PrDi,
			name.c_str());
	os << buf;
}

int ProcmemParser::setTotal(const std::string& line)
{
	std::string name;
	std::shared_ptr<ProcMemData> data(new ProcMemData);
	if( parseLine(line, m_total, name) == false ) {
		return -1;
	}
	return 0;
}

bool ProcmemParser::ComparePss::operator()(const pair_t& p1, const pair_t& p2)
{
	return p1.second->Pss > p2.second->Pss;
}

//bool ProcmemParser::ComparePss(const pair_t& p1, const pair_t& p2)

void ProcmemParser::dump(std::ostream& os)
{
	ComparePss cmp;
	std::vector<pair_t> arr;
	for( auto it=m_proc_map.begin(); it != m_proc_map.end(); it++ ) {
		arr.push_back(make_pair(it->first, it->second));
	}

	sort(arr.begin(),arr.end(),cmp);

	if( m_pid >= 0 ) {
		os << "pid is " << m_pid << std::endl;
	}
	os << "     Vss      Rss      Pss      Uss     ShCl     ShDi    PrCl      PrDi  Name\n";
	os << "-------- -------- -------- -------- -------- -------- -------- --------\n";
	//for( map_t::iterator it=m_proc_map.begin(); it != m_proc_map.end(); it++ ) {
	for( auto it=arr.begin(); it != arr.end(); it++ ) {
		dumpData(*(it->second), it->first.c_str(), os);
	}
	os << "-------- -------- -------- -------- -------- -------- -------- --------\n";
	dumpData(m_total, "TOTAL", os);
	dumpData(m_stack_xxx, "[stack:xxxx]", os);
}


