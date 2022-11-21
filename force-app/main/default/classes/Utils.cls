public with sharing class Utils {
    
    /**
     * @return the current ESAPI SFDCAccessController object being used to maintain the access control rules for this application. 
     */
    public static SFDCAccessController Auth {
        get {
            if (Auth == null) {
                Auth = new SFDCAccessController();
            }
            return Auth;
        } private set;
    }
    
    
    public static String toISOStringFromDate(Date dt) {
        return dt == null ? null : dt.year() + '-' 
            + (dt.month() < 10 ? '0' : '') + dt.month() + '-' 
            + (dt.day() < 10 ? '0' : '') + dt.day();
    }
    
    public static Date toDateFromISOString(String dtStr) {
        Date dt = null;
        
        if (!String.isBlank(dtStr)) {
            List<String> dateParts = dtStr.split('-');
            dt = Date.newInstance(Integer.valueOf(dateParts[0]),Integer.valueOf(dateParts[1]) , Integer.valueOf(dateParts[2]));
        }     
        return dt;
    }
    
    public static List<Schema.SObjectField> sobjFieldsFromFieldSet(Schema.FieldSet reqdFieldSet, Schema.SObjectType sobjType) {
        List<Schema.FieldSetMember> fieldsetList = reqdFieldSet.getFields();
        Map<String, Schema.SObjectField> fieldMap = sobjType.getDescribe().fields.getMap();
        List<Schema.SObjectField> fields = new List<Schema.SObjectField>();
        for (Schema.FieldSetMember fieldmem : fieldsetList) {
            String fieldName = fieldmem.getFieldPath();
            fields.add(fieldMap.get(fieldName));
        }
        return fields;
    }
    
    public static List<String> fieldsFromFieldSet(Schema.FieldSet reqdFieldSet, Schema.SObjectType sobjType) {
        List<Schema.FieldSetMember> fieldsetList = reqdFieldSet.getFields();
        Map<String, Schema.SObjectField> fieldMap = sobjType.getDescribe().fields.getMap();
        List<String> fields = new List<String>();
        for (Schema.FieldSetMember fieldmem : fieldsetList) {
            String fieldName = fieldmem.getFieldPath();
            Schema.DescribeFieldResult fldDesc = fieldMap.get(fieldName).getDescribe();
            if(!fldDesc.isAccessible()) continue;
            Schema.DisplayType fielddataType = fldDesc.getType();
            String fldName = fieldmem.getFieldPath().toLowerCase();
            fields.add(fldName);
        }
        return fields;
    }
    
     public static List<String> parentFieldsFromFieldSet(Schema.FieldSet reqdFieldSet) {
        List<Schema.FieldSetMember> fieldsetList = reqdFieldSet.getFields();
        List<String> fields = new List<String>();
        
        for (Schema.FieldSetMember fieldmem : fieldsetList) {  String fldName = fieldmem.getFieldPath().toLowerCase();    fields.add(fldName);
        }
        return fields;
    }
    
   /* public static String asCSV(List<Schema.FieldSetMember> fldSetFlds) {
        String csv = '';
        for (Schema.FieldSetMember fsm : fldSetFlds) {
            csv += fsm.getFieldPath() + ',';
        }
        // remove the last comma from the csv
        if(csv!=''){
          csv = csv.removeEnd(',');
        }
        return csv;
    }
    public static String asCSVForIds(Set<Id> ids) {
        String csv = '';
        for (Id id1 : ids) {
            csv += '\''+id1 +'\''+ ',';
        }
        // remove the last comma from the csv
        csv = csv.substring(0, csv.length() - 1);
        return csv;
    }*/
    
    /**
        Returns given List as CSV
    */
    public static String toCSV(List<Object> vals) {
        return split(vals, ',');
    } 
    
    /**
        Splits the given list by delimeter
    */
    public static String split(List<Object> vals, String delimeter) {
        String splt = '';
        if (vals != null) {
            for (Object val : vals) {
                splt += (splt.length() == 0) ? val : delimeter + val;
            }
        }
        return splt;
    }
    
    public static String getNamespace() {
		return Utils.class.getName().substringBefore('Utils').substringBefore('.');
	}
	
	public static String namespace(String name) {
		String namespace = getNamespace();
		return (String.isBlank(namespace) ? name : (namespace + '__' + name));
	}

	public static void sortSelectOptionsByLabel(List<SelectOption> selectOptions) {
		Map<String, SelectOption> selectOptionMap = new Map<String, SelectOption>();

		for (Integer i = 0; i < selectOptions.size(); i++) {
			selectOptionMap.put(selectOptions[i].getLabel() + i, selectOptions[i]);
		}

		List<String> keys = new List<String>(selectOptionMap.keySet());
		keys.sort();

		selectOptions.clear();

		for (String key : keys) {
			selectOptions.add(selectOptionMap.get(key));
		}
	}
    
}