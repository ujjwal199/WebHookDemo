/**
 * Functions for Action Status
 */
function disableOnClick() {
    $(".btn").toggleClass('btnDisabled', true).attr('disabled', 'disabled');
}

function enableOnClick() {
    $(".btn").toggleClass('btnDisabled', false).attr('disabled', null);
}

function showDialog(hiddendiv,title) {
    // if you want to use it in a button make sure you require jQuery 

    // get the dialog with your dialog name 
    d = sfdcPage.dialogs['addInternalAd'], close;
    if (!d) {
        // if the dialog doesn't exist create one 
        d = sfdcPage.dialogs['addInternalAd'] = new SimpleDialog('addInternalAd', false);
        // set general information on your dialog and finally run the create function 
        d.setTitle(''+title);
         d.setWidth(950);
        d.createDialog();
    }
    // give your dialog some content (I usually use an iframe linking to another visualforce page 
    // change the url, height, width to your needs 
    $(d.dialog).find('#addInternalAdInner').css('max-height', '500px');
    $(d.dialog).find('#addInternalAdInner').css('overflow', 'auto');
    var content = $('#'+hiddendiv).html();
    $('#'+hiddendiv).html('');
    
    $(d.dialog).find('#addInternalAdInner').html("<div id='popupdiv'>" + content + "</div>");

    
    // we also need to make sure we have a close button on the dialog 
    if ($(d.dialog).find('#InlineEditDialogX').size() == 0) {
        // if there is none we create it 
        close = $('<a id="InlineEditDialogX" title="Close" tabindex="0" href="javascript:void(0)" class="dialogClose">Close</a>');
        // add some functionality to the close button (for the default ui we change the classname on mouseover/out 
        //if ($.browser.webkit) {
            close.mouseover(function() {
                this.className = 'dialogCloseOn';
            }).mouseout(function() {
                this.className = 'dialogClose';
            }).click(function() {
                // finally our on click handler which closes the dialog 
              if($('#popupdiv').find('table.list').length>0){    
               // $('#'+hiddendiv).html($('#popupdiv').html());
              }    
               // d.hide();
               closeWindow();
            });
            // insert the new generated close button before the h2 tag so it'll show up on the top right corner 
            close.insertBefore($(d.dialog).find('.topLeft h2'));
       // }
    }
    // now it's time to show the new dialog 
    d.show();
}

function printReviewDetail() {
    //var cssDetail= $("head").html();
    var divContents = $("html").html();
    var printWindow = window.open('', '', 'height=400,width=800');
    printWindow.document.write('<html><head><title>DSR Review</title>');
    printWindow.document.write('</head><body >');
    printWindow.document.write(divContents);
    printWindow.document.write('</body></html>');
    printWindow.document.close();
    printWindow.print();
}




function hidePopup(hiddendiv){
      if($('#popupdiv').find('table.list').length>0){    
        $('#'+hiddendiv).html($('#popupdiv').html());
     }
     
      d.hide();
}


var _DSRApp = (function($) {  
    
    var app = {
        // shared kendo template for error messages
        _errorMsgTemplate: null, 
        
        state : {
            _loadHiddenInputById : function(inputId) {
                return $('input[type=hidden][id$=' + inputId + ']');
            },
            hiddenInput : function(inputId) {
                var elemHiddenInput = this._loadHiddenInputById(inputId);
                return arguments && arguments.length > 1 ? elemHiddenInput.val(arguments[1]) : elemHiddenInput.val();
            },
            _toHiddenGetterSetter : function(inputId, args) {
                var newArgs = Array.prototype.slice.call(args);
                newArgs.unshift(inputId);
                return this.hiddenInput.apply(this, newArgs);
            },
            dsrId : function() {
              return $('span[id=dsrIdHolder]').html();  
            },
            selectedSite : function() {
                return this._toHiddenGetterSetter('selectedSite', arguments);
            },
            selectedSiteName : function() {
                return this._toHiddenGetterSetter('selectedSiteName', arguments);
            },
            selectedPrimaryDate : function() {
                return this._toHiddenGetterSetter('selectedPrimaryDate', arguments);
            },
            selectedAlternateDate : function() {
                return this._toHiddenGetterSetter('selectedAlternateDate', arguments);
            },
            selectedStartTime : function() {
                return this._toHiddenGetterSetter('selectedStartTime', arguments);
            },
             selectedEndTime : function() {
                return this._toHiddenGetterSetter('selectedEndTime', arguments);
            },
             selectedMeetingDurationType : function() {
                return this._toHiddenGetterSetter('selectedMeetingDuration', arguments);
            },
            clearAll : function() {
                this.selectedSite('');
                this.selectedSiteName('');
                this.selectedPrimaryDate('');
                this.selectedAlternateDate('');
                this.selectedMeetingDurationType('');
                this.selectedStartTime('');
                this.selectedEndTime('');
            }
        },
        
        
        init : function() {
            var _initOnReady = function() {
                // Kendo Template
                app._errorMsgTemplate = kendo.template($("#error-msg-template").html());
            }
            
            app.util.onReadyCallback(_initOnReady);
        },
        
        util : {
            isDOMReady : function() {
                return jQuery.isReady;
            },
            onReadyCallback : function(callback) {
                if ( jQuery.isReady) {  
                    // usually the case when sites tab is not the first tab 
                  callback();
                } else {
                    // in case sites tab becomes first one to load
                   $(document).ready(callback);  
                }   
            },
            showErrors : function(errors, keepShowing) {
                $('#errorsPanel').html(app._errorMsgTemplate({errors: errors}));
                if (!keepShowing) {
                    setTimeout(function(){
                      $('#errorsPanel').html('');
                    }, 5000);
                }
            }
        },
        
        attendees : {
          validate : function() {
              var errors = [];
              if ($('input[type=checkbox][id$=attendee]:checked').length <= 0) {
                  errors.push(_sfdcPageData.labels.msg_dsr_no_contact);
              }
              return errors;
          },
          
          toNextSection : function() {
                var errors = this.validate();
                if (errors.length)  {
                    app.util.showErrors(errors);
                } else {
                    afOnSaveAttendees();
                }
            },
            
        },
        
        
        // Sites app
        sites : {
            _rightPanelTemplate : null,
            _tdRightPanel : null,
            
            init : function() {
                var that = this;
                var _init = function() {
                    that._tdRightPanel = $('td#rightPanel');    
                    that._rightPanelTemplate = kendo.template($("#cal-topics-template").html());
                    var siteid = app.state.selectedSite();
                    if (siteid) that.select(siteid, false);   
                }
                
                app.util.onReadyCallback(_init);
            },
            validate : function() {
                var errors = [];
                if (!app.state.selectedSite()) {
                    errors.push('No site is selected');
                } 
                if (!app.state.selectedPrimaryDate()) {
                    errors.push('No primary date is selected');
                } 
                if (!app.state.selectedAlternateDate()) {
                    errors.push('No alternate date is selected');
                }
                return errors;
            },
            updateRightPanel : function(templateVars){
                templateVars = $.extend(
                    {
                        processing : false
                    }, 
                    templateVars);
                // apply template 
                this._tdRightPanel.html(this._rightPanelTemplate(templateVars));            
            },
            
            toNextSection : function() {
               
                var errors = this.validate();
                if (errors.length)  {
                    app.util.showErrors(errors);
                } else {
                    afGototSitesNext();
                }
            }, 
                
            select: function( siteId, clearState) {
                var radioCell = $('input[type=radio][value=' + siteId +']');
                // bad input
                if (!radioCell.length) return;
                
                var siteName = radioCell.data('sitename');
                // highlight row
                $(radioCell)
                    .prop('checked', true)
                    .closest('tr')
                    .addClass('active-site')
                    .siblings().removeClass('active-site');
                
                if (clearState) app.state.clearAll();
                
                app.state.selectedSite(siteId);
                app.state.selectedSiteName(siteName);
            
                app.sites.showDetailsForSite(siteId, siteName);
            },
             
             selectedMeetingDurationType: function(type) {
                 app.state.selectedMeetingDurationType(type);
             },
             
            showDetailsForSite : function(siteId, siteName) {
                var that = this;
                this.updateRightPanel({siteName: 'Processing...', processing: true});
             
                Visualforce.remoting.Manager.invokeAction( 
                    _sfdcPageData.remoteActions.fetchCalendarDates,
                    siteId,
                    function(result, event) {
                        
                        that.updateRightPanel({siteName: siteName});
                        
                        if (event.status) {
                           
                            that._prepareCalendars(result);
                        } else if (event.type === 'exception') {
                            document.getElementById("responseErrors").innerHTML =
                                event.message + "<br/>\n<pre>" + event.where + "</pre>";
                        } else {
                            document.getElementById("responseErrors").innerHTML = event.message;
                        }
                    }, {
                        escape: true
                    }
                );
            },
            
            // private functions
            _prepareCalendars : function(result) {
                var today = new Date();
                var disabledDates = [];
                for (var idx = 0; idx < result.length; idx++) {
                    var dt = result[idx];
                    var jsDate = new Date(dt.start);
                    if (dt.available) {
                        // later
                    } else {
                        disabledDates.push(jsDate);
                    }
                }
                var sharedMDPCfg = {
                    gotoCurrent: true,
                    mode: 'daysRange',
        	        autoselectRange: [0,1],
                    minDate: 0,
                    maxDate: 90,
                    addDisabledDates: disabledDates && disabledDates.length ? disabledDates : null,
                    altFormat: "DD, d MM, yy",
                    onSelect : function(date, calObj) {
                        var dateVal = $(this).multiDatesPicker('value');
                      
                        var displayVal = dateVal && $.datepicker.formatDate(calObj.settings.altFormat, new Date(date)) || '';
                        $(calObj.settings.altField).html(displayVal); 
                        app.state.hiddenInput(calObj.settings.altFieldInputId, calObj.currentYear + '-' + (calObj.currentMonth + 1) + '-' + calObj.currentDay );
                    }
                };
                
                var defPrimaryDate = app.state.selectedPrimaryDate();
                var defAltDate = app.state.selectedAlternateDate();
                
                var primDateCfg = {
                    altField: "#primaryCalendarAlt",
                    altFieldInputId: "selectedPrimaryDate"
                };
                
                var altDateCfg = {
                    altField: "#secondaryCalendarAlt",
                    altFieldInputId: "selectedAlternateDate"
                };
                
                if (defPrimaryDate) {
                      primDateCfg.addDates = [new Date(defPrimaryDate)];
                      var displayVal = defPrimaryDate && $.datepicker.formatDate("DD, d MM, yy", new Date(defPrimaryDate)) || '';
                      $(primDateCfg.altField).html(displayVal); 
                }        
               
                if (defAltDate) {
                     altDateCfg.addDates = [new Date(defAltDate)];
                     var displayVal = defAltDate && $.datepicker.formatDate("DD, d MM, yy", new Date(defAltDate)) || '';
                    $(altDateCfg.altField).html(displayVal); 
                }
                
                $('#primaryCalendar').multiDatesPicker(jQuery.extend(primDateCfg, sharedMDPCfg));
                
                $('#secondaryCalendar').multiDatesPicker(jQuery.extend(altDateCfg, sharedMDPCfg));
                
                this._prepareTimestamp();
            },
            
            _prepareTimestamp: function() {
                 var interval=600;
                var siteId= app.state.selectedSite();
                var timeDuration = $('input[type=radio][value=' + siteId + ']').parent().parent().find('.hrsopperation').html();
                var startEndTime = timeDuration.split('-');
            
                var start = $(".start").kendoTimePicker({
                    change:startChange,
                    format: "hh:mm tt",
                    parseFormats: ["HH:mm:ss","HH:mm"],
                    interval:60
                }).data("kendoTimePicker");
            
                var end = $(".end").kendoTimePicker({
                    change:endChange,
                    format: "hh:mm tt",
                    parseFormats: ["HH:mm:ss","HH:mm"],
                     interval:60
                }).data("kendoTimePicker");
             
               if(startEndTime!='undefined' && startEndTime.length>0){
                var startTime = startEndTime[0].trim();
                var endTime = startEndTime[1].trim();
                //define min/max range
                start.min(startTime);
                start.max(endTime);
            
                //define min/max range
                end.min(startTime);
                end.max(endTime);
                
                var startDefaultTime = start.value();
                var startTime = (startDefaultTime>start.min()?startDefaultTime:start.min()); 
                 
                 
                 start.value(startTime);
                
                startTime.setMinutes(startTime.getMinutes() + interval);
                if(end.max()>=startTime){
                    end.value(startTime);
                }else if(startTime>end.max()){
                    end.value(end.max());
                }
                
                 //app.state.selectedStartTime(start.value());
                // app.state.selectedEndTime(end.value());
                
                
                 var selecteduration = app.state.selectedMeetingDurationType();
                 if(selecteduration!='' && typeof selecteduration!='undefined'){
                      app.state.selectedMeetingDurationType(selecteduration);
                      $(".meetingId").val(app.state.selectedMeetingDurationType());
                 }else{
                    app.state.selectedMeetingDurationType($(".meetingId").val());
                 }
                 
                  var stratTimeValue=app.state.selectedStartTime();
                   if(stratTimeValue!='' && typeof stratTimeValue!=='undefined'){
                       app.state.selectedStartTime(stratTimeValue);
                      // stratTimeValue=(stratTimeValue>start.min()?stratTimeValue:start.min()); 
                       start.value(stratTimeValue);
                   }else{
                       app.state.selectedStartTime(start._oldText);
                   }
                  
                   var EndTimeValue=app.state.selectedEndTime();
                   if(EndTimeValue!='' && typeof EndTimeValue!=='undefined'){
                       app.state.selectedEndTime(EndTimeValue);
                        //stratTimeValue=(stratTimeValue>start.min()?startDefaultTime:start.min()); 
                       end.value(EndTimeValue);
                   }else{
                        app.state.selectedEndTime(end._oldText);
                   }
                 
                 
                
               }    
         
                function startChange() {
                     var startTime =start._oldText;// start.value();
                     app.state.selectedStartTime(startTime);
                      
                }
                
                function endChange() {
                    var endTime =end._oldText;// end.value();
                    app.state.selectedEndTime(endTime);
                }        
                
            }

            
        },
        
        // Topics APP
        topics : {
            validate : function() {
                var errors = [];
                // nothing for now
                return errors;
            },
            toNextSection : function() {
                var errors = this.validate();
                if (errors.length)  {
                    app.util.showErrors(errors);
                } else {
                    afNextFromTopics();
                }
            },
            
            _grid : {
                selector : "#topicsGrid",
                
                remoting : {
                    loadDSRTopics : function() {
                      	var deferred = $.Deferred();
                        Visualforce.remoting.Manager.invokeAction(
                            _sfdcPageData.remoteActions.fetchDSRTopics,
                            app.state.dsrId(), 
                            function (result, event) {
                                deferred.resolve(result, event);
                            },
                            {escape: false}
                        );
                        return deferred.promise();
                    },
                    loadAPITopics : function() {
                      	var deferred = $.Deferred();
                        Visualforce.remoting.Manager.invokeAction(
                            _sfdcPageData.remoteActions.fetchAPITopics,
                            app.state.selectedSite(), 
                            function (result, event) {
                                deferred.resolve(result, event);
                            },
                            {escape: false}
                        );
                        return deferred.promise();
                    }, 
                    upsertTopic : function(topic) {
                      	var deferred = $.Deferred();
                        Visualforce.remoting.Manager.invokeAction(
                            _sfdcPageData.remoteActions.upsertTopic,
                            topic, 
                            function (result, event) {
                                deferred.resolve(result, event);
                            },
                            {escape: false}
                        );
                        return deferred.promise();
                    }, 
                    deleteTopic : function(topicId) {
                      	var deferred = $.Deferred();
                        Visualforce.remoting.Manager.invokeAction(
                            _sfdcPageData.remoteActions.deleteTopic,
                            topicId, 
                            function (result, event) {
                                deferred.resolve(result, event);
                            },
                            {escape: false}
                        );
                        return deferred.promise();
                    }
                }, 
                
                schema: {
                     model: {
                             id : "id",
                             fields: {
                                 categoryName: {
                                     type: "string",
                                     editable : false
                                 },
                                 categoryId: {
                                     type: "string",
                                     editable : false
                                 },
                                 duration: {
                                     type: "number"
                                 },
                                 id: {
                                     type: "string",
                                     editable : false
                                 },
                                 apiId: {
                                     type: "string"
                                 },
                                 name: {
                                     type: "string",
                                     validation: {
                                        required: true
                                     }
                                 },
                                 notes : {
                                     type: "string"
                                 }
                             }
                         }
                 },
                
                transport : {
                    upsert : function(options){
                        var topic = options.data;
                        if (!topic.dsrId) {
                            topic.dsrId = app.state.dsrId();
                        }
        		        var promise = app.topics._grid.remoting.upsertTopic(topic);
        				promise.done(function(result, event){
        			        	if (event.type == 'exception') {
        			        		alert("An error occurred while processing your request. Please contact support"); 
        						} else {
        			            	options.success(result);
        						}
        	            });
        		        
        		    },
        		    create : function(options){
        		        app.topics._grid.transport.upsert(options);
        		    },
        		    update : function(options){
        		        app.topics._grid.transport.upsert(options);
        		    },
                    destroy : function(options){
                        var topicId = options.data.id; 
        		        var promise = app.topics._grid.remoting.deleteTopic(topicId);
        				promise.done(function(result, event){
        			        	if (event.type == 'exception') {
        			        		alert("An error occurred while processing your request. Please contact support"); 
        						} else {
        			            	options.success(result);
        						}
        	            });
        		        
        		    },
        		    read :function (options) {
    					var promise = app.topics._grid.remoting.loadDSRTopics();
    					promise.done(function(result, event){
    				        	if (event.type == 'exception') {
    				        		alert("An error occurred while processing your request. Please contact support"); 
    							} else {
    				            	options.success(result);
    							}
    		            });
    			    }
                }
            },
            
            init : function(topics) {
                if (!app.util.isDOMReady) {
                    app.util.onReadyCallback(app.topics.init);
                    return;
                }
                // hide info message
                setTimeout(function(){
                      $('span[id$=topicInfoMsg]').fadeOut('slow');
                    }, 5000);
                
                $(app.topics._grid.selector).kendoGrid({
                     dataSource: {
                         group: { field: "categoryName" },
                         transport: app.topics._grid.transport,
                         schema: app.topics._grid.schema,
                         pageSize: 20
                     },
                     toolbar: [
                         { name: "create", text: "Add new Topic" }
                     ],
                     groupable : false, 
                     editable: "inline",
                     scrollable: true,
                     sortable: true,
                     filterable: false,
                     pageable: {
                         input: true,
                         numeric: false
                     },
                     columns: [
                         {
                             field: "categoryName",
                             title: "Category",
                             width: "80px",
                             hidden : true,
                             groupHeaderTemplate : " #= value ? value : '' # "
                         }, 
                         
                         {
                             field: "name",
                             title: "Name",
                             width: "130px",
                             editor : function(container, options) {
                                 var kendoComboBox = 
                                         $('<input required data-text-field="name" data-value-field="id" data-bind="value:' + options.field + '"/>')
                                            .appendTo(container)
                                            .kendoComboBox({
                                                placeholder : 'Type to search...',
                                                autoBind : false,
                                                minLength : 0,
                                                dataValueField : 'apiId',
                                                dataTextField : 'name',
                                                filter : 'contains',
                                                orderByField : null, 
                                                sortOrder : null,
                                                value : options.model.apiId,
                                                text : options.model.name,
                                                dataSource: {
                                                    transport: {
                                        				read: function (options) {
                                        					var promise = app.topics._grid.remoting.loadAPITopics();
                                        					promise.done(function(result, event){
                                        				        	if (event.type == 'exception') {
                                        				        		alert("An error occurred while processing your request. Please contact support"); 
                                        							} else {
                                        				            	options.success(result);
                                        							}
                                        			            });
                                        				    }
                                        			},
                                                    group: {
                                                        field: "categoryName"
                                                    }
                                                },
                                                select : function(e) {
                                                    var dataItem = this.dataItem(e.item.index());
                                                    var model = options.model;
                                                    model.set('name', dataItem.name);
                                                    model.set('apiId', dataItem.apiId);
                                                    model.set('categoryName', dataItem.categoryName);
                                                    model.set('categoryId', dataItem.categoryId);
                                                    // doing this because of some kendo bug, where the select properties are not updated in model
                                                    model.categoryId = dataItem.categoryId;
                                                    model.categoryName = dataItem.categoryName;
                                                }
                                            }).data('kendoComboBox'); 
                                            
                                         $('<span class="k-invalid-msg" data-for="name"></span>').appendTo(container);    
                            }
                         }, 
                         
                         {
                             field: "notes",
                             title: "Notes",
                             width: "230px"
                         },
                         { 
                             command: ["edit", "destroy"], title: "Action", width: "60px" 
                         }
                     ]
                 });
                
            }
            
        }
        
    
    }
    
    return app;
    
})(jQuery);


