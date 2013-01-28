


//dUMPING THE jstREE, BUT KEEPING THIS HERE AS A REF

function start_tree() {

alert("instarttree");
var data = [
 {
 'data' : false,
 'attr': {'rel': 'directory'}
 }];

    $('#coltree').jstree({
            json_data: {data: data},
            plugins: ['themes', 'json_data', 'ui', 'crrm',
                      'contextmenu', 'dnd'],
            core: { },
            dnd: {
                 "drop_finish": function (data) {
                                                alert("some message");
                                                },

                 },            

            contextmenu: {'select_node': true,
                          'items': {'load': {'label': 'Edit module',
                                           'action': function(obj) {node_load_event(obj);}
                                          },
                                   'create': false,
                                   'rename': false,
                                   'delete': false,
                                   'edit': false,
                                   'remove':false,
                                   'ccp':false
                                 }
                           }

                         })

                         .bind("delete.jstree", function(e, data) {alert("Delete TBD");
                                                    });
}

function populate_tree(jsonstr) {

    logout(jsonstr);
    x = $.parseJSON(jsonstr);

    var jsTreeSettings = $('#coltree').jstree('get_settings');
    jsTreeSettings.json_data.data = x; //$.parseJSON(jsonstr);
    $.jstree._reference('coltree')._set_settings(jsTreeSettings);

    // Refresh whole our tree (-1 means root of tree)
    $.jstree._reference('coltree').refresh(-1);
}

