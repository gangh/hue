#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Licensed to Cloudera, Inc. under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  Cloudera, Inc. licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from nose.tools import assert_equal, assert_true

from indexer.api3 import _create_table_from_a_file


class MockRequest():
  def __init__(self, fs=None):
    self.fs = fs if fs is not None else MockFs()


class MockFs():
  def __init__(self, isDir=False):
    self.isDir = isDir

  def isdir(self, path):
    return self.isDir

  def split(self, path):
    return '/A', 'a'

  def listdir(self, path):
    return ['/A']


def test_generate_create_kudu_table_with_data():
  source = {u'sampleCols': [], u'name': u'', u'inputFormat': u'file', u'format': {u'quoteChar': u'"', u'recordSeparator': u'\\n', u'type': u'csv', u'hasHeader': True, u'fieldSeparator': u','}, u'show': True, u'tableName': u'', u'sample': [], u'defaultName': u'index_data', u'query': u'', u'databaseName': u'default', u'table': u'', u'inputFormats': [{u'name': u'File', u'value': u'file'}, {u'name': u'Manually', u'value': u'manual'}], u'path': u'/user/admin/index_data.csv', u'draggedQuery': u'', u'isObjectStore': False}
  destination = {u'KUDU_DEFAULT_PARTITION_COLUMN': {u'int_val': 16, u'name': u'HASH', u'columns': [], u'range_partitions': [{u'include_upper_val': u'<=', u'upper_val': 1, u'name': u'VALUES', u'include_lower_val': u'<=', u'lower_val': 0, u'values': [{u'value': u''}]}]}, u'tableName': u'index_data', u'outputFormatsList': [{u'name': u'Table', u'value': u'table'}, {u'name': u'Solr+index', u'value': u'index'}, {u'name': u'File', u'value': u'file'}, {u'name': u'Database', u'value': u'database'}], u'customRegexp': u'', u'isTargetExisting': False, u'partitionColumns': [], u'useCustomDelimiters': True, u'kuduPartitionColumns': [{u'int_val': 16, u'name': u'HASH', u'columns': [u'id'], u'range_partitions': [{u'include_upper_val': u'<=', u'upper_val': 1, u'name': u'VALUES', u'include_lower_val': u'<=', u'lower_val': 0, u'values': [{u'value': u''}]}]}], u'outputFormats': [{u'name': u'Table', u'value': u'table'}, {u'name': u'Solr+index', u'value': u'index'}], u'customMapDelimiter': None, u'showProperties': False, u'useDefaultLocation': True, u'description': u'', u'primaryKeyObjects': [{u'operations': [], u'comment': u'', u'name': u'id', u'level': 0, u'keyType': u'string', u'required': False, u'nested': [], u'isPartition': False, u'length': 100, u'multiValued': False, u'unique': False, u'type': u'string', u'showProperties': False, u'keep': True}], u'customFieldDelimiter': u',', u'existingTargetUrl': u'', u'importData': True, u'databaseName': u'default', u'KUDU_DEFAULT_RANGE_PARTITION_COLUMN': {u'include_upper_val': u'<=', u'upper_val': 1, u'name': u'VALUES', u'include_lower_val': u'<=', u'lower_val': 0, u'values': [{u'value': u''}]}, u'primaryKeys': [u'id'], u'outputFormat': u'table', u'nonDefaultLocation': u'/user/admin/index_data.csv', u'name': u'index_data', u'tableFormat': u'kudu', u'bulkColumnNames': u'business_id,cool,date,funny,id,stars,text,type,useful,user_id,name,full_address,latitude,longitude,neighborhoods,open,review_count,state', u'columns': [{u'operations': [], u'comment': u'', u'name': u'business_id', u'level': 0, u'keyType': u'string', u'required': False, u'nested': [], u'isPartition': False, u'length': 100, u'multiValued': False, u'unique': False, u'type': u'string', u'showProperties': False, u'keep': True}, {u'operations': [], u'comment': u'', u'name': u'cool', u'level': 0, u'keyType': u'string', u'required': False, u'nested': [], u'isPartition': False, u'length': 100, u'multiValued': False, u'unique': False, u'type': u'bigint', u'showProperties': False, u'keep': True}, {u'operations': [], u'comment': u'', u'name': u'date', u'level': 0, u'keyType': u'string', u'required': False, u'nested': [], u'isPartition': False, u'length': 100, u'multiValued': False, u'unique': False, u'type': u'string', u'showProperties': False, u'keep': True}, {u'operations': [], u'comment': u'', u'name': u'funny', u'level': 0, u'keyType': u'string', u'required': False, u'nested': [], u'isPartition': False, u'length': 100, u'multiValued': False, u'unique': False, u'type': u'bigint', u'showProperties': False, u'keep': True}, {u'operations': [], u'comment': u'', u'name': u'id', u'level': 0, u'keyType': u'string', u'required': False, u'nested': [], u'isPartition': False, u'length': 100, u'multiValued': False, u'unique': False, u'type': u'string', u'showProperties': False, u'keep': True}, {u'operations': [], u'comment': u'', u'name': u'stars', u'level': 0, u'keyType': u'string', u'required': False, u'nested': [], u'isPartition': False, u'length': 100, u'multiValued': False, u'unique': False, u'type': u'bigint', u'showProperties': False, u'keep': True}, {u'operations': [], u'comment': u'', u'name': u'text', u'level': 0, u'keyType': u'string', u'required': False, u'nested': [], u'isPartition': False, u'length': 100, u'multiValued': False, u'unique': False, u'type': u'string', u'showProperties': False, u'keep': True}, {u'operations': [], u'comment': u'', u'name': u'type', u'level': 0, u'keyType': u'string', u'required': False, u'nested': [], u'isPartition': False, u'length': 100, u'multiValued': False, u'unique': False, u'type': u'string', u'showProperties': False, u'keep': True}, {u'operations': [], u'comment': u'', u'name': u'useful', u'level': 0, u'keyType': u'string', u'required': False, u'nested': [], u'isPartition': False, u'length': 100, u'multiValued': False, u'unique': False, u'type': u'bigint', u'showProperties': False, u'keep': True}, {u'operations': [], u'comment': u'', u'name': u'user_id', u'level': 0, u'keyType': u'string', u'required': False, u'nested': [], u'isPartition': False, u'length': 100, u'multiValued': False, u'unique': False, u'type': u'string', u'showProperties': False, u'keep': True}, {u'operations': [], u'comment': u'', u'name': u'name', u'level': 0, u'keyType': u'string', u'required': False, u'nested': [], u'isPartition': False, u'length': 100, u'multiValued': False, u'unique': False, u'type': u'string', u'showProperties': False, u'keep': True}, {u'operations': [], u'comment': u'', u'name': u'full_address', u'level': 0, u'keyType': u'string', u'required': False, u'nested': [], u'isPartition': False, u'length': 100, u'multiValued': False, u'unique': False, u'type': u'string', u'showProperties': False, u'keep': True}, {u'operations': [], u'comment': u'', u'name': u'latitude', u'level': 0, u'keyType': u'string', u'required': False, u'nested': [], u'isPartition': False, u'length': 100, u'multiValued': False, u'unique': False, u'type': u'double', u'showProperties': False, u'keep': True}, {u'operations': [], u'comment': u'', u'name': u'longitude', u'level': 0, u'keyType': u'string', u'required': False, u'nested': [], u'isPartition': False, u'length': 100, u'multiValued': False, u'unique': False, u'type': u'double', u'showProperties': False, u'keep': True}, {u'operations': [], u'comment': u'', u'name': u'neighborhoods', u'level': 0, u'keyType': u'string', u'required': False, u'nested': [], u'isPartition': False, u'length': 100, u'multiValued': False, u'unique': False, u'type': u'string', u'showProperties': False, u'keep': True}, {u'operations': [], u'comment': u'', u'name': u'open', u'level': 0, u'keyType': u'string', u'required': False, u'nested': [], u'isPartition': False, u'length': 100, u'multiValued': False, u'unique': False, u'type': u'string', u'showProperties': False, u'keep': True}, {u'operations': [], u'comment': u'', u'name': u'review_count', u'level': 0, u'keyType': u'string', u'required': False, u'nested': [], u'isPartition': False, u'length': 100, u'multiValued': False, u'unique': False, u'type': u'bigint', u'showProperties': False, u'keep': True}, {u'operations': [], u'comment': u'', u'name': u'state', u'level': 0, u'keyType': u'string', u'required': False, u'nested': [], u'isPartition': False, u'length': 100, u'multiValued': False, u'unique': False, u'type': u'string', u'showProperties': False, u'keep': True}], u'hasHeader': True, u'tableFormats': [{u'name': u'Text', u'value': u'text'}, {u'name': u'Parquet', u'value': u'parquet'}, {u'name': u'Json', u'value': u'json'}, {u'name': u'Kudu', u'value': u'kudu'}, {u'name': u'Avro', u'value': u'avro'}, {u'name': u'Regexp', u'value': u'regexp'}, {u'name': u'RCFile', u'value': u'rcfile'}, {u'name': u'ORC', u'value': u'orc'}, {u'name': u'SequenceFile', u'value': u'sequencefile'}], u'customCollectionDelimiter': None}
  request = MockRequest(fs=MockFs())

  sql = _create_table_from_a_file(request, source, destination).get_str()

  assert_true('''DROP TABLE IF EXISTS `default`.`hue__tmp_index_data`;''' in  sql, sql)

  assert_true('''CREATE EXTERNAL TABLE `default`.`hue__tmp_index_data`
(
  `business_id` string ,
  `cool` bigint ,
  `date` string ,
  `funny` bigint ,
  `id` string ,
  `stars` bigint ,
  `text` string ,
  `type` string ,
  `useful` bigint ,
  `user_id` string ,
  `name` string ,
  `full_address` string ,
  `latitude` double ,
  `longitude` double ,
  `neighborhoods` string ,
  `open` string ,
  `review_count` bigint ,
  `state` string )  ROW FORMAT   DELIMITED
    FIELDS TERMINATED BY ','
  STORED AS TextFile LOCATION '/A'
TBLPROPERTIES("skip.header.line.count" = "1")''' in  sql, sql)

  assert_true('''CREATE TABLE `default`.`index_data`
      PRIMARY KEY (id)
      PARTITION BY HASH PARTITIONS 16
      STORED AS kudu
      TBLPROPERTIES(
      'kudu.num_tablet_replicas' = '1'
      )
      AS SELECT `id`, `business_id`, `cool`, `date`, `funny`, `stars`, `text`, `type`, `useful`, `user_id`, `name`, `full_address`, `latitude`, `longitude`, `neighborhoods`, `open`, `review_count`, `state`
      FROM `default`.`hue__tmp_index_data`;''' in  sql, sql)
