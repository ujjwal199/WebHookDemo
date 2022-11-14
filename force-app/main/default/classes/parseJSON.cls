public class parseJSON{
	public List<Data> data {get;set;} 
	public class Data{
		public String name {get;set;} 
		public List<FormFields> formFields {get;set;} 	
        
	}
	public class FormFields {
		public String name {get;set;} 
		public String label {get;set;} 
        public String type_formatted {get;set;}
	}
	public static parseJSON parse(String json) {
        return (parseJSON) System.JSON.deserialize(json, parseJSON.class);
    }
    
}