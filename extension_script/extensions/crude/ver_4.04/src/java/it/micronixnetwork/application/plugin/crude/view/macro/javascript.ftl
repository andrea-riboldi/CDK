<#macro objDelete prototype cardId="${cardId}" >		
    <#assign prototypeName=prototype.substring(prototype.lastIndexOf('.')+1)!''/>
    $('#${cardId}_delete_button').click(function(){
        // Controllo presenza checkbox selezionati
        active=false;
        $('.${cardId}_${prototypeName}_selectable').each(function(){
          if($(this).attr('checked')=='checked'){
                  active=true;
          };
          return !active;
        });
        if(active){
            ${cardId}_show_overlay(true,'search_ui');
            var card_width=$("#${cardId}_card").width();
            $trg=$('#${cardId}_remove_object_confirm_dialog');
            var left=(card_width-$trg.width())/2;
            $trg.css('left',left);
            $trg.animate({top: "0"}, 500);
        }
        return false;
    });

    $('#${cardId}_${prototypeName}_object_delete_cancel_button').click(function(){
        $('#${cardId}_remove_object_confirm_dialog').animate({top: "-100%"}, 500,function(){
                ${cardId}_show_overlay(false,'search_ui');
        });
    });

    $('#${cardId}_${prototypeName}_object_delete_apply_button').click(function(){
        ${cardId}_set_list_message("");
        $('#${cardId}_remove_object_confirm_dialog').animate({top: "-100%"}, 500,function(){
            ${cardId}_show_overlay(false,'search_ui');
            $('#${cardId}_remove_object_action').show();
            clearForm($('#${cardId}_remove_object_form'));
            addHiddenToForm($('#${cardId}_remove_object_form'),'targetClass','${prototype}');
            $('.${cardId}_${prototypeName}_selectable').each(function(){
              if($(this).attr('checked')=='checked'){
                    ${cardId}_fillPrimarykeyData($(this).parent().parent().parent('tr'),$('#${cardId}_remove_object_form'));
              };
            });
            callEvent("${cardId}_remove_object_refresh");
        });
    });

		
</#macro>	

<#macro objInsert prototype cardId="${cardId}" save_and_go=false>		
    <#assign prototypeName=prototype.substring(prototype.lastIndexOf('.')+1)!''/>
    <#if save_and_go>
    $('#${cardId}_create_button').click(function(){
        clearForm($('#${cardId}_get_object_form'));
        copyForm($("#${cardId}_get_object_form"), $("#${cardId}_${prototypeName}_form"));
        callEvent("${cardId}_${prototypeName}_new_ui_new_object_refresh");
        });
    <#else>
    $('#${cardId}_create_button').click(function(){
        $('#${cardId}_${prototypeName}_new_ui_new_object_action').show();
        clearForm($('#${cardId}_get_object_form'));
        copyForm($("#${cardId}_get_object_form"), $("#${cardId}_${prototypeName}_form"));
        //addHiddenToForm($('#${cardId}_get_object_form'),'targetClass','${prototype}');
        $('#${cardId}_${prototypeName}_new_ui_insert_object_action_content').empty();
        $('#${cardId}_${prototypeName}_new_ui_get_obj_action_content').empty();
        $('#${cardId}_${prototypeName}_new_ui_insert_object_action .div_asinc_content').html('<span class="${cardId}_event_message animated flash">${action.getText("crude.form.rquired")}</span>');
        callEvent("${cardId}_${prototypeName}_new_ui_new_object_refresh");
        ${cardId}_slideToPage($('#${cardId}_list_slide'),$('#${cardId}_${prototypeName}_new_object_pane'), 'right');
        $('#${cardId}_${prototypeName}_form [name="inCreate"]').val('true');
    });
    </#if>
		
    $('#${cardId}_${prototypeName}_new_cancel_button,#${cardId}_${prototypeName}_new_end_button').click(function(){
        ${cardId}_slideToPage($('#${cardId}_${prototypeName}_new_object_pane'),$('#${cardId}_list_slide'), 'left');
    });
		
    $('#${cardId}_${prototypeName}_new_update_button').click(function(){
        $('#${cardId}_${prototypeName}_new_ui_update_object_action').show();
        clearForm($("#${cardId}_object_form_post"));
        copyForm($("#${cardId}_object_form_post"), $("#${cardId}_new_ui_form"));
        addHiddenToForm($('#${cardId}_object_form_post'),'targetClass','${prototype}');
        callEvent("${cardId}_${prototypeName}_new_ui_update_object_refresh");
    });
		
    $('#${cardId}_${prototypeName}_new_save_button').click(function(){
        $('#${cardId}_${prototypeName}_new_ui_insert_object_action').show();
        clearForm($("#${cardId}_object_form_post"));
        copyForm($("#${cardId}_object_form_post"), $("#${cardId}_new_ui_form"));
        addHiddenToForm($('#${cardId}_object_form_post'),'targetClass','${prototype}');
        callEvent("${cardId}_${prototypeName}_new_ui_insert_object_refresh");
    });
</#macro>	

<#macro objUpdate prototype cardId="${cardId}" directEdit="false">		
    <#assign prototypeName=prototype.substring(prototype.lastIndexOf('.')+1)!''/>
    $('#${cardId}_${prototypeName}_info_cancel_button').click(function(){
        $('#${cardId}_${prototypeName}_view_ui_info_obj_action').show();
        $('#${cardId}_${prototypeName}_view_ui_get_obj_action').hide();
        <#if directEdit="false">
                callEvent("${cardId}_${prototypeName}_view_ui_info_object_refresh");
        <#else>
                ${cardId}_slideToPage($('#${cardId}_${prototypeName}_view_object_pane'),$('#${cardId}_list_slide'), 'left');
        </#if>
    });
		
    $('#${cardId}_${prototypeName}_info_modify_button').click(function(){
        $('#${cardId}_${prototypeName}_view_ui_info_obj_action').hide();
        $('#${cardId}_${prototypeName}_view_ui_info_obj_action_content').empty();
        $('#${cardId}_${prototypeName}_view_ui_get_obj_action').show();
        $('#${cardId}_${prototypeName}_view_ui_update_object_action').show();
        $('#${cardId}_${prototypeName}_view_ui_update_object_action .div_asinc_content').html('<span class="${cardId}_event_message animated flash">${action.getText("crude.form.rquired")}</span>');
        callEvent("${cardId}_${prototypeName}_view_ui_get_object_refresh");
    });
		
		$('#${cardId}_${prototypeName}_info_update_button').click(function(){
			clearForm($("#${cardId}_object_form_post"));
			$("#${cardId}_view_main_object_form .right_input_multiselect.TakeOver option").attr("selected", "selected");
			copyForm($("#${cardId}_object_form_post"), $("#${cardId}_view_ui_form"));
			addHiddenToForm($('#${cardId}_object_form_post'),'targetClass','${prototype}');
			callEvent("${cardId}_${prototypeName}_view_ui_update_object_refresh");
		});
</#macro>	

<#macro formatFunctions cardId="${cardId}">		
/**
 * Formatta un campo di input di tipo valuta
 */
function ${cardId}_inputCurrencyFormat(input) {
	// Trasformazione in numero del contenuto dell'input
	toProcess = input.val();
	last = toProcess[toProcess.length - 1];
	numValue = unformatNumber(toProcess, '.', ',');
	value = formatCurrency(numValue, '.', ',', 2, true);
	if (last == ',')
		value += ',';
	input.val(value);
};

/**
 * Formatta un campo di input di tipo data
 */
function ${cardId}_inputDateFormat(input) {
	toProcess = input.val();
	input.val(toProcess);
};

/**
 * Formatta un campo di input di tipo reale
 */
function ${cardId}_inputRealFormat(input) {
	toProcess = input.val();
	last = toProcess[toProcess.length - 1];
	numValue = unformatNumber(toProcess, '.', ',');
	value = formatCurrency(numValue, '.', ',', null, true);
	if (last == ',')
		value += ',';
	input.val(value);
};

/**
 * Formatta un campo di input di tipo intero
 */
function ${cardId}_inputIntegerFormat(input) {
	value = ${cardId}_forceDigit(input.val());
	input.val(value);
};

/**
 * Elimina da un testo tutto quello che non è un numero
 */
function ${cardId}_forceDigit(text) {
	regexp = new RegExp("[^\\d-]", "g");
	result = text.replace(regexp, '');
	return result;
};

/**
 * controllo di abilitazione alla formattazione di un input
 */
function ${cardId}_checkKey(e) {
	var e = window.event || e;
	var keyUnicode = e.charCode || e.keyCode;
	if (e !== undefined) {
		switch (keyUnicode) {
		case 16:
			break; // Shift
		case 17:
			break; // Ctrl
		case 18:
			break; // Alt
		case 27:
			input.val('');
			break; // Esc: clear entry
		case 35:
			break; // End
		case 36:
			break; // Home
		case 37:
			break; // cursor left
		case 38:
			break;// cursor up
		case 39:
			break;// cursor right
		case 40:
			break;// cursor down
		case 78:
			break; // N (Opera 9.63+ maps the "." from the number key section
					// to the "N" key too!) (See:
					// http://unixpapa.com/js/key.html search for ". Del")
		default: {
			return true;
		}
		}
	}
	return false;
};

</#macro>

<#macro filterEvents prototype cardId="${cardId}" >		
	<#assign prototypeName=prototype.substring(prototype.lastIndexOf('.')+1)!''/>
		//Gestione click sul bottone applica filtro
	 	$('#${cardId}_filter_button').click(function (){
	 		callEvent('${cardId}_${prototypeName}_find_refresh');
	 		return false;
	 	});	

	 	//Gestione click sul bottone reset filtro
	 	$('#${cardId}_reset_filter_button').click(function (){
	 		$('#${cardId}_${prototypeName}_form :text').val('');
	   		$('#${cardId}_${prototypeName}_form :input').removeAttr('checked');
	   		$('#${cardId}_${prototypeName}_form select option').removeAttr('selected');
	   		$('#${cardId}_${prototypeName}_form select option:first').attr('selected',true);
	 		//$("#${cardId}_${prototypeName}_form :hidden.filter_field ").val('');
	 		$('#${cardId}_${prototypeName}_form [name="toOrder"]').val('');
	 		callEvent('${cardId}_${prototypeName}_find_refresh');
	 		return false;
	 	});		
	 	
	 	//Gestione dell'evento di change sulle combo presenti nel filtro
	 	$( "#${cardId}_${prototypeName}_form select").change(function(){
	 		callEvent('${cardId}_${prototypeName}_find_refresh');
		});
	 	
	 	//Applicazione plugin DatePicker ai campi dati del filtro e gestione dell'evento di selezione
	 	$( "#${cardId}_${prototypeName}_form .date_input").datepicker({
			changeMonth: true,
			changeYear: true,
			numberOfMonths: 1,
			onSelect: function( selectedDate ) {
				callEvent('${cardId}_${prototypeName}_find_refresh');
			}
		});
</#macro>


<#macro general prototype cardId="${cardId}" >		
<#assign prototypeName=prototype.substring(prototype.lastIndexOf('.')+1)!''/>
/**
* attiva e disattiva il div di copertura per la funzione modale dei dialog
*/
function ${cardId}_show_overlay(flag,view){
			if(flag){
				$('#${cardId}_overlay_'+view).css('visibility','visible');
				$('#${cardId}_overlay_'+view).css('opacity','1');
			}else{
				$('#${cardId}_overlay_'+view).css('visibility','hidden');
				$('#${cardId}_overlay_'+view).css('opacity','0');
			}
}

/**
* Scorrimento orrizzontale dei pannelli list/view/insert
*/
function ${cardId}_slideToPage($current,$page, startPosition) {
		$page.attr( "class", "${cardId}_page " + startPosition);
 		$page.show(0,function(){
 			$page.attr( "class", "${cardId}_page transition origin");
        	$current.attr( "class","${cardId}_page transition " + (startPosition === "left" ? "right" : "left"));
 		});
        $current.addClass('animated fadeOut');
};

function ${cardId}_fillPrimarykeyData($ele,$form){
	$($ele[0].attributes).each(function() {
		var attName=this.nodeName;
		var attValue=this.nodeValue;
		var fieldName;
		if(attName.indexOf('pk_')!=-1){
			fieldName=attName.substr(3);
			addHiddenToForm($form,"idObj['"+fieldName+"']",attValue);
		}
	});
};

function ${cardId}_set_list_message(msg){
	if(msg==null){
		msg='${action.getText(prototypeName+".list.message")}';
	}
	$('#${cardId}_list_slide_message').html('<span id="${cardId}_event_message" class="${cardId}_event_message">'+msg+'</span>');
}

function ${cardId}_set_list_error_message(msg){
	if(msg==null){
		msg='${action.getText(prototypeName+".list.message")}';
	}
	$('#${cardId}_list_slide_message').html('<span id="${cardId}_event_message" style="color:red" class="${cardId}_event_message animated flash">'+msg+'</span>');
}


function ${cardId}_resizeList(){
	var wdgHeader_h=$('#${cardId}_card .card-header').outerHeight(true)+6;

	var width=$('#${cardId}_card').width();
			if(width<806){
				$('#${cardId}_card .${cardId}_cbp-mc-column').width('100%');
			}else{
				$('#${cardId}_card .${cardId}_cbp-mc-column').width('');
	}
	
	//Calcolo altezza pannello lista ricerca
	var title_h=$('#${cardId}_list_slide .${cardId}_form_title').outerHeight(true);
	var filter_form_h=$('#${cardId}_${prototypeName}_form').outerHeight(true);
	var header_h=30;
	var footer_h=45
	var delta=title_h+filter_form_h+header_h+footer_h+wdgHeader_h;
	var list_h=$('#${cardId}_card').innerHeight()-delta;
	${cardId}_${prototypeName}_table.fnSettings().oScroll.sY=list_h;
	$('#${cardId}_${prototypeName}_list_zone').height(list_h+header_h);	
	try{	
	${cardId}_${prototypeName}_table.fnDraw();
	${cardId}_${prototypeName}_table.fnAdjustColumnSizing();
	}catch(err){
		console.log(err);
	}
}

function ${cardId}_resizeView(){
	var wdgHeader_h=$('#${cardId}_card .card-header').outerHeight(true)+6;
	title_h=$('#${cardId}_${prototypeName}_view_object_pane .${cardId}_form_title').outerHeight(true);
	delta=title_h+wdgHeader_h;
	view_h=$('#${cardId}_card').innerHeight()-delta;	
	$('#${cardId}_${prototypeName}_view_ui_scroll').height(view_h);
}

function ${cardId}_resizeNew(){
	var wdgHeader_h=$('#${cardId}_card .card-header').outerHeight(true)+6;
	title_h=$('#${cardId}_${prototypeName}_new_object_pane .${cardId}_form_title').outerHeight(true);
	delta=title_h+wdgHeader_h;
	view_h=$('#${cardId}_card').innerHeight()-delta;	
	$('#${cardId}_${prototypeName}_new_ui_scroll').height(view_h);
}

function ${cardId}_on_layout_resize(){
	${cardId}_resizeList();
	${cardId}_resizeView();
	${cardId}_resizeNew();
}

</#macro>
