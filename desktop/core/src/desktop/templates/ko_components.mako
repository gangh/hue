## Licensed to Cloudera, Inc. under one
## or more contributor license agreements.  See the NOTICE file
## distributed with this work for additional information
## regarding copyright ownership.  Cloudera, Inc. licenses this file
## to you under the Apache License, Version 2.0 (the
## "License"); you may not use this file except in compliance
## with the License.  You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.

<%!
from desktop import conf
from desktop.lib.i18n import smart_unicode
from django.utils.translation import ugettext as _
%>

<%def name="assistPanel()">
  <style>
    .assist-tables {
      margin-left: 7px;
    }

    .assist-tables a {
      text-decoration: none;
    }

    .assist-tables li {
      list-style: none;
    }

    .assist-tables > li {
      margin-bottom: 5px;
    }

    .assist-table-link {
      font-size: 13px;
    }

    .assist-column-link {
      font-size: 12px;
    }

    .assist-table-link,
    .assist-table-link:focus {
      color: #444;
    }

    .assist-column-link,
    .assist-column-link:focus {
      color: #737373;
    }

    .assist-column-link:hover,
    .assist-table-link:hover {
      color: #338bb8;
    }

    .assist-columns {
      margin-left: 0px;
    }

    .assist-columns > li {
      padding: 6px 5px;
    }

    .assist-column .column-actions,
    .assist-table .table-actions {
      opacity: 0;
      position:absolute;
      right: 0;
      padding-left:3px;
      background-color: #FFF;
      transition: opacity 0.2s linear, color 0.2s ease;
    }

    .column-actions > a,
    .table-actions > a {
      color: #D1D1D1;
      transition: color 0.2s ease;
    }

    .column-actions > a:hover,
    .table-actions > a:hover {
      color: #338bb8;
    }

    .assist-column:hover .column-actions,
    .assist-table:hover .table-actions {
      opacity: 1;
    }

    .table-actions:hover {
      color: #338bb8;
    }

    .assist-action {
      margin-left: 3px;
      color: #D1D1D1;
      opacity:0;
      transition: opacity 0.2s linear, color 0.2s ease;
    }

    .assist-container:hover .assist-action {
      opacity:1;
    }

    .assist-action:hover {
      color: #338bb8;
    }
  </style>

  <script type="text/html" id="assist-panel-table-stats">
    <div class="content">
      <!-- ko if: statRows().length -->
      <table class="table table-striped">
        <tbody data-bind="foreach: statRows">
          <tr><th data-bind="text: data_type"></th><td data-bind="text: comment"></td></tr>
        </tbody>
      </table>
      <!-- /ko -->
    </div>
  </script>

  <script type="text/html" id="assist-panel-column-stats">
    <div class="pull-right hide filter">
      <input id="columnAnalysisTermsFilter" type="text" placeholder="${ _('Prefix filter...') }"/>
    </div>
    <ul class="nav nav-tabs" role="tablist">
      <li class="active"><a href="#columnAnalysisStats" role="tab" data-toggle="tab">${ _('Stats') }</a></li>
      <li><a href="#columnAnalysisTerms" role="tab" data-toggle="tab">${ _('Terms') }</a></li>
    </ul>
    <div class="tab-content">
      <div class="tab-pane active" id="columnAnalysisStats" style="text-align: left">
        <div class="content">
          <table class="table table-striped">
            <tbody data-bind="foreach: statRows">
              <tr><th data-bind="text: Object.keys($data)[0]"></th><td data-bind="text: $data[Object.keys($data)[0]]"></td></tr>
            </tbody>
          </table>
        </div>
      </div>
      <div class="tab-pane" id="columnAnalysisTerms" style="text-align: left">
        <i style="margin: 5px;" data-bind="visible: loadingTerms" class='fa fa-spinner fa-spin'></i>
        <div class="alert" data-bind="visible: !loadingTerms() && terms().length == 0">${ _('There are no terms to be shown') }</div>
        <div class="content">
          <table class="table table-striped">
            <tbody data-bind="foreach: terms">
              <tr><td data-bind="text: name"></td><td style="width: 40px"><div class="progress"><div class="bar-label" data-bind="text: count"></div><div class="bar bar-info" style="margin-top: -20px;" data-bind="style: { 'width' : percent + '%' }"></div></div></td></tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </script>

  <script type="text/html" id="assist-panel-template">
    <div style="position: relative;">
      <ul class="nav nav-list" style="float:left; border: none; padding: 0; background-color: #FFF; margin-bottom: 1px; width: 100%;">
        <li class="nav-header">${_('database')}
          <i title="${_('Manually refresh the table list')}" class="pull-right pointer assist-action fa fa-refresh" data-bind="click: reloadAssist"></i>
        </li>
        <!-- ko if: assist.mainObjects().length > 0 -->
        <li>
          <select data-bind="options: assist.mainObjects, select2: { width: '100%', placeholder: '${ _("Choose a database...") }', update: assist.selectedMainObject}" class="input-medium" data-placeholder="${_('Choose a database...')}"></select>
          <div data-bind="visible: Object.keys(assist.firstLevelObjects()).length == 0">${_('The selected database has no tables.')}</div>
        </li>
        <li class="nav-header" style="margin-top:10px;">${_('tables')}
          <i class="assist-action pointer pull-right fa fa-search" data-bind="click: toggleSearch"></i>
        </li>
        <li>
          <div data-bind="slideVisible: options.isSearchVisible"><input type="text" placeholder="${ _('Table name...') }" style="width:90%;" data-bind="value: assist.filter, valueUpdate: 'afterkeydown'"/></div>
          <ul class="assist-tables" data-bind="visible: Object.keys(assist.firstLevelObjects()).length > 0, foreach: assist.filteredFirstLevelObjects()">
            <li class="assist-table" style="position:relative;">
              <div class="table-actions">
                <a href="javascript:void(0)" class="preview-sample" data-bind="click: $parent.showTablePreview"><i class="fa fa-list" title="${_('Preview Sample data')}"></i></a>
                <a href="javascript:void(0)" class="table-stats" data-bind="click: function(data, event) { $parent.showStats(data, null, event) }"><i class='fa fa-bar-chart' title="${_('View statistics') }"></i></a>
              </div>
              <a class="assist-table-link" href="javascript:void(0)" data-bind="click: $parent.loadAssistSecondLevel, event: { 'dblclick': function(){ huePubSub.publish('assist.dblClickItem', $data); }, text: $data }"><span data-bind="text: $data"></span></a>
              <div data-bind="visible: $parent.assist.firstLevelObjects()[$data].loaded() && $parent.assist.firstLevelObjects()[$data].open()">
                <ul class="assist-columns" data-bind="visible: $parent.assist.firstLevelObjects()[$data].items().length > 0, foreach: $parent.assist.firstLevelObjects()[$data].items()">
                  <li class="assist-column">
                    <div class="column-actions">
                      <a href="javascript:void(0)" class="table-stats" data-bind="click: function(data, event) { $parents[1].showStats($parent, data.name, event) }"><i class='fa fa-bar-chart' title="${_('View statistics') }"></i></a>
                    </div>
                    <a class="assist-column-link" data-bind="attr: {'title': $parents[1].secondLevelTitle($data)}" style="padding-left:10px" href="javascript:void(0)"><span data-bind="html: $parents[1].truncateSecondLevel($data), event: { 'dblclick': function() { huePubSub.publish('assist.dblClickItem', $data.name +', '); } }"></span></a>
                  </li>
                </ul>
              </div>
            </li>
          </ul>
        </li>
        <!-- /ko -->
        <!-- ko if: assist.isLoading() || assist.hasErrors() -->
        <li>
          <div id="navigatorLoader" class="center"  data-bind="visible: assist.isLoading">
            <!--[if !IE]><!--><i class="fa fa-spinner fa-spin" style="font-size: 20px; color: #BBB"></i><!--<![endif]-->
            <!--[if IE]><img src="${ static('desktop/art/spinner.gif') }"/><![endif]-->
          </div>
          <div class="center" data-bind="visible: assist.hasErrors">
            ${ _('The database list cannot be loaded.') }
          </div>
        </li>
        <!-- /ko -->
      </ul>
    </div>

    <div id="assistQuickLook" class="modal hide fade">
      <div class="modal-header">
        <a href="#" class="close" data-dismiss="modal">&times;</a>
        <h3>${_('Data sample for')} <span class="tableName"></span></h3>
      </div>
      <div class="modal-body" style="min-height: 100px">
        <div class="loader">
          <!--[if !IE]><!--><i class="fa fa-spinner fa-spin" style="font-size: 30px; color: #DDD"></i><!--<![endif]-->
          <!--[if IE]><img src="${ static('desktop/art/spinner.gif') }"/><![endif]-->
        </div>
        <div class="sample"></div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-primary disable-feedback" data-dismiss="modal">${_('Ok')}</button>
      </div>
    </div>

    <div id="tableAnalysis" style="position: fixed; display: none;" class="popover show mega-popover right" data-bind="visible: analysisStats() != null, with: analysisStats">
      <div class="arrow"></div>
      <h3 class="popover-title" style="text-align: left">
        <a class="pull-right pointer close-popover" style="margin-left: 8px" data-bind="click: function() { $parent.analysisStats(null) }"><i class="fa fa-times"></i></a>
        <span class="pull-right stats-warning muted" data-bind="visible: inaccurate" rel="tooltip" data-placement="top" title="${ _('The column stats for this table are not accurate') }" style="margin-left: 8px"><i class="fa fa-exclamation-triangle"></i></span>
        <i data-bind="visible: loading" class='fa fa-spinner fa-spin'></i>
        <!-- ko if: column == null -->
        <strong class="table-name" data-bind="text: table"></strong> ${ _(' table analysis') }
        <!-- /ko -->
        <!-- ko ifnot: column == null -->
        <strong class="table-name" data-bind="text: column"></strong> ${ _(' column analysis') }
        <!-- /ko -->
      </h3>
      <div class="popover-content">
        <!-- ko template: {if: column == null, name: 'assist-panel-table-stats' } --><!-- /ko -->
        <!-- ko template: {ifnot: column == null, name: 'assist-panel-column-stats' } --><!-- /ko -->
      </div>
    </div>
  </script>

  <script type="text/javascript" charset="utf-8">
    (function() {
      function AssistPanel(params) {
        var self = this;

        self.assistAppName = params.assistAppName || "beeswax";
        self.options = ko.mapping.fromJS($.extend({
          isSearchVisible: false,
          lastSelectedDb: null
        }, $.totalStorage(params.appName + ".assist.options") || {}));

        $.each(Object.keys(self.options), function (index, key) {
          if (ko.isObservable(self.options[key])) {
            self.options[key].subscribe(function() {
              $.totalStorage(params.appName + ".assist.options", ko.mapping.toJS(self.options))
            });
          }
        });

        self.assist = params.assist;

        self.toggleSearch = function () {
          self.options.isSearchVisible(!self.options.isSearchVisible());
        };

        self.modalItem = ko.observable();
        self.analysisStats = ko.observable();

        self.secondLevelTitle = function(level) {
          var _title = "";

          if (level.comment && needsTruncation(level)) {
            _title = level.name + " (" + level.type + "): " + level.comment;
          } else if (needsTruncation(level)) {
            _title = level.name + " (" + level.type + ")";
          } else if (level.comment) {
            _title = level.comment;
          }
          return _title;
        };

        var needsTruncation = function(level) {
          return (level.name.length + level.type.length) > 20;
        };

        self.truncateSecondLevel = function(level) {
          var escapeString = function (str) {
            return $("<span>").text(str).html().trim()
          };
          if (needsTruncation(level)) {
            return escapeString(level.name + " (" + level.type + ")").substr(0, 20) + "&hellip;";
          }
          return escapeString(level.name + " (" + level.type + ")");
        };

        self.loadAssistMain = function(force) {
          self.assist.options.onDataReceived = function (data) {
            if (data.databases) {
              self.assist.mainObjects(data.databases);
              if (force) {
                self.loadAssistFirstLevel(force);
              }
              else if (self.assist.mainObjects().length > 0 && !self.assist.selectedMainObject()) {
                if (self.options.lastSelectedDb() != null && $.inArray(self.options.lastSelectedDb(), self.assist.mainObjects()) > -1) {
                  self.assist.selectedMainObject(self.options.lastSelectedDb());
                } else if ($.inArray("default", self.assist.mainObjects()) > -1) {
                  self.assist.selectedMainObject("default");
                } else {
                  self.assist.selectedMainObject(self.assist.mainObjects()[0]);
                }
                self.loadAssistFirstLevel();
              }
            }
          };
          self.assist.options.onError = function() {
            self.assist.isLoading(false);
          };
          self.assist.getData(null, force);

          self.assist.selectedMainObject.subscribe(function(value) {
            self.options.lastSelectedDb(value);
            self.loadAssistFirstLevel();
            huePubSub.publish('assist.mainObjectChange', value);
          });
        };

        self.loadAssistFirstLevel = function(force) {
          var self = this;
          self.assist.options.onDataReceived = function (data) {
            if (data.tables) {
              var _obj = {};
              data.tables.forEach(function (item) {
                _obj[item] = {
                  items: ko.observableArray([]),
                  open: ko.observable(false),
                  loaded: ko.observable(false)
                }
              });
              self.assist.firstLevelObjects(_obj);
            }
            self.assist.isLoading(false);
          };
          self.assist.getData(self.assist.selectedMainObject(), force);
        };

        self.loadAssistSecondLevel = function(first) {
          if (!self.assist.firstLevelObjects()[first].loaded()) {
            self.assist.isLoading(true);
            self.assist.options.onDataReceived = function (data) {
              if (data.columns) {
                var _cols = data.extended_columns ? data.extended_columns : data.columns;
                self.assist.firstLevelObjects()[first].items(_cols);
                self.assist.firstLevelObjects()[first].loaded(true);
              }
              self.assist.isLoading(false);
            };
            self.assist.getData(self.assist.selectedMainObject() + "/" + first);
          }
          self.assist.firstLevelObjects()[first].open(!self.assist.firstLevelObjects()[first].open());
          window.setTimeout(self.resizeAssist, 100);
        };

        self.reloadAssist = function() {
          self.loadAssistMain(true);
        };

        self.showTablePreview = function(table) {
          var tableUrl = "/" + self.assistAppName + "/api/table/" + self.assist.selectedMainObject() + "/" + table;
          $("#assistQuickLook").find(".tableName").text(table);
          $("#assistQuickLook").find(".tableLink").attr("href", "/metastore/table/" + self.assist.selectedMainObject() + "/" + table);
          $("#assistQuickLook").find(".sample").empty("");
          $("#assistQuickLook").attr("style", "width: " + ($(window).width() - 120) + "px;margin-left:-" + (($(window).width() - 80) / 2) + "px!important;");
          $.ajax({
            url: tableUrl,
            data: {"sample": true},
            beforeSend: function (xhr) {
              xhr.setRequestHeader("X-Requested-With", "Hue");
            },
            dataType: "html",
            success: function (data) {
              $("#assistQuickLook").find(".loader").hide();
              $("#assistQuickLook").find(".sample").html(data);
            },
            error: function (e) {
              if (e.status == 500) {
                $(document).trigger("error", "${ _('There was a problem loading the table preview.') }");
                $("#assistQuickLook").modal("hide");
              }
            }
          });
          $("#assistQuickLook").modal("show");
        };

        function TableStats (assistAppName, database, table, column) {
          var self = this;

          self.table = table;
          self.column = column;
          self.loading = ko.observable(false);
          self.loadingTerms = ko.observable(false);
          self.inaccurate = ko.observable(false);
          self.statRows = ko.observableArray();
          self.terms = ko.observableArray();

          self.fetchTerms = function () {
            self.loadingTerms(true);
            $.ajax({
              url: "/" + assistAppName + "/api/table/" + database + "/" + table + "/terms/" + column + "/",
              data: {},
              beforeSend: function (xhr) {
                xhr.setRequestHeader("X-Requested-With", "Hue");
              },
              dataType: "json",
              success: function (data) {
                if (data && data.status == 0) {
                  self.terms($.map(data.terms, function (term) {
                    return {
                      name: term[0],
                      count: term[1],
                      percent: (parseFloat(term[1]) / parseFloat(data.terms[0][1])) * 100
                    }
                  }));
                } else {
                  $("#tableAnalysis").hide();
                  $(document).trigger("error", options.errorLabel);
                }
              },
              error: function (e) {
                if (e.status == 500) {
                  $("#tableAnalysis").hide();
                  $(document).trigger("error", options.errorLabel);
                }
              },
              complete: function () {
                self.loadingTerms(false);
              }
            });
          };

          self.fetchData = function() {
            self.loading(true);
            $.ajax({
              url: "/" + assistAppName + "/api/table/" + database + "/" + table + "/stats/" + (column || ""),
              data: {},
              beforeSend: function (xhr) {
                xhr.setRequestHeader("X-Requested-With", "Hue");
              },
              dataType: "json",
              success: function (data) {
                if (data && data.status == 0) {
                  self.statRows(data.stats);
                  for(var i = 0; i < data.stats.length; i++) {
                    if (data.stats[i].data_type == "COLUMN_STATS_ACCURATE" && data.stats[i].comment == "false") {
                      self.inaccurate(true);
                      break;
                    }
                  }
                } else {
                  $("#tableAnalysis").hide();
                  $(document).trigger("error", options.errorLabel);
                }
              },
              error: function (e) {
                if (e.status == 500) {
                  $("#tableAnalysis").hide();
                  $(document).trigger("error", options.errorLabel);
                }
              },
              complete: function () {
                self.loading(false);
              }
            });
          };

          self.fetchData();
          if (this.column != null) {
            self.fetchTerms();
          }
        }

        var lastOffset = { top: -1, left: -1 };
        var $tableAnalysis = $("#tableAnalysis");
        var refreshPosition = function () {
          var targetElement = $tableAnalysis.data("targetElement");
          if (targetElement != null && targetElement.is(":visible")) {
            if (targetElement != null && (lastOffset.left != targetElement.offset().left || lastOffset.top != targetElement.offset().top)) {
              lastOffset = targetElement.offset();
              $tableAnalysis.css("top", lastOffset.top - $tableAnalysis.outerHeight() / 2 + targetElement.outerHeight() / 2).css("left", lastOffset.left + targetElement.outerWidth());
            }
          } else {
            $tableAnalysis.hide();
          }
        };
        window.setInterval(refreshPosition, 200);

        self.showStats = function (table, column, event) {
          self.analysisStats(new TableStats(self.assistAppName, self.assist.selectedMainObject(), table, column));
          $("#tableAnalysis").data("targetElement", $(event.target));
          window.setTimeout(refreshPosition, 20);
        };

        if (self.assist.options.baseURL != ""){
          self.loadAssistMain();
        }

        var $assistMain = $(".assist-tables");
        $assistMain.scroll(function() {
          $assistMain.find(".table-actions").css('right', -$assistMain.scrollLeft() + 'px');
        });
      }

      ko.components.register('assist-panel', {
        viewModel: AssistPanel,
        template: { element: 'assist-panel-template' }
      });
    }());
  </script>
</%def>

<%def name="jvmMemoryInput()">
  <script type="text/html" id="jvm-memory-input-template">
    <input type="text" class="input-small" data-bind="textInput: value" /> <select class="input-mini" data-bind="options: units, value: selectedUnit" />
  </script>

  <script type="text/javascript" charset="utf-8">
    (function() {
      var JVM_MEM_PATTERN = /([0-9]+)([MG])$/;
      var UNITS = { 'MB' : 'M', 'GB' : 'G' };

      function JvmMemoryInputViewModel(params) {
        this.valueObservable = params.value;
        this.units = Object.keys(UNITS);
        this.selectedUnit = ko.observable();
        this.value = ko.observable().extend({ 'numeric' : 0 });

        var match = JVM_MEM_PATTERN.exec(this.valueObservable());
        if (match.length === 3) {
          this.value(match[1]);
          this.selectedUnit(match[2] === 'M' ? 'MB' : 'GB');
        }

        this.value.subscribe(this.updateValueObservable, this);
        this.selectedUnit.subscribe(this.updateValueObservable, this);
      }

      JvmMemoryInputViewModel.prototype.updateValueObservable = function() {
        if (isNaN(this.value()) || this.value() === '') {
          this.valueObservable(undefined);
        } else {
          this.valueObservable(this.value() + UNITS[this.selectedUnit()]);
        }
      };

      ko.components.register('jvm-memory-input', {
        viewModel: JvmMemoryInputViewModel,
        template: { element: 'jvm-memory-input-template' }
      });
    }());
  </script>
</%def>