public class Cliente{
    public Id ClienteId {get;set;}
  
    public cliente() {
     //   RichiedenteId = 'a0F58000001HrZI';
     ClienteId=ApexPages.currentPage().getParameters().get('id');

    }
}