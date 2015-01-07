package com.uprush.hdemo;

import backtype.storm.topology.BasicOutputCollector;
import backtype.storm.topology.IBasicBolt;
import backtype.storm.topology.OutputFieldsDeclarer;
import backtype.storm.topology.base.BaseBasicBolt;
import backtype.storm.tuple.Tuple;

public class HelloStormBolt extends BaseBasicBolt implements IBasicBolt {

	public void execute(Tuple tuple, BasicOutputCollector collector) {
		System.out.println(tuple);
	}

	public void declareOutputFields(OutputFieldsDeclarer ofd) {
	}

}