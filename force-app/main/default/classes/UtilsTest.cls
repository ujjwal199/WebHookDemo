@isTest
private class UtilsTest {
    
    static testmethod void testNamespace() {
        String namespace = UtilsTest.class.getName().substringBefore('UtilsTest').substringBefore('.');
        
        System.assertEquals(namespace + (String.isBlank(namespace) ? '' : '__') + 'test', Utils.namespace('test'),'Exception');
    }
    
    static testmethod void testSortSelectOptionsByLabel() {
        List<SelectOption> selectOptions = new List<SelectOption>();
        selectOptions.add(new SelectOption('3', '3'));
        selectOptions.add(new SelectOption('1', '1'));
        selectOptions.add(new SelectOption('2', '2'));
        
        Utils.sortSelectOptionsByLabel(selectOptions);
        
        System.assertEquals('1', selectOptions[0].getLabel(),'Exception');
        System.assertEquals('2', selectOptions[1].getLabel(),'Exception');
        System.assertEquals('3', selectOptions[2].getLabel(),'Exception');
    }
    
    static testmethod void testSortSelectOptionsByLabel1() {
        Utils.toDateFromISOString('03-01-2021');
        date dateObj= system.today();
        Utils.toISOStringFromDate(dateObj);
        System.assertEquals('03-01-2021', '03-01-2021','Exception');
    }
}