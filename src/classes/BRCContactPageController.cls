public with sharing class BRCContactPageController {

    public Boolean survey { get; set; }
    public String surveyName { get; set; }
    public String surveyHeader { get; set; }
    public String surveyId {
        get;
        set {
            this.surveyId = value;
            init();
        }
    }
    public List<SelectOption> singleOptions { get; set; }
    public List<SFQuestion> allQuestions { get; set; }
    public String surveyThankYouText { get; set; }
    public String surveyContainerCss { get; set; }
    public String surveyThankYouURL { get; set; }
    public String leadId { get; set; }
    public String baseURL { get; set; }
    public String surveyTakerId { get; set; }
    public Boolean thankYouRendered { get; set; }
    private String acceptJoin;
    public String retURL {get; set;}
    public String leadSource {get; set;}
    public String webToLeadOid {get; set;}

    public BRCContactPageController(ApexPages.StandardController stdController) {
        retURL = BRCUtils.getCredentialsValues('BRCContactFormRetUrl');
        leadSource = BRCUtils.getCredentialsValues('BRCWebFormLeadSource');
        webToLeadOid = BRCUtils.getCredentialsValues('BRCContactFormWebToLeadOid');
        surveyId = ApexPages.currentPage().getParameters().get('id');
        leadId = ApexPages.currentPage().getParameters().get('lId');
        init();
        survey = (String.isBlank(surveyId))? false : true;
    }

    public void init() {
        if (surveyId != null) {
            allQuestions = new List<SFQuestion>();
            setupQuestionList();
            setSurveyNameAndThankYou(surveyId);
            String urlBase = URL.getSalesforceBaseUrl().toExternalForm();
            baseURL = urlBase;
            thankYouRendered = false;
        }
    }

    public Integer setupQuestionList() {
        getAQuestion();
        return allQuestions.size();
    }

    public void setSurveyNameAndThankYou(String sId) {
        Survey__c s = [SELECT Name, Id, URL__c, Thank_You_Text__c, thankYouText__c, thankYouLink__c, Survey_Header__c, Survey_Container_CSS__c FROM Survey__c WHERE Id = :sId];
        surveyName = s.Name;
        surveyHeader = s.Survey_Header__c;
        surveyThankYouText = s.Thank_You_Text__c;
        if (surveyThankYouText == null) {
            surveyThankYouText = System.Label.LABS_SF_Survey_Submitted_Thank_you;
        }
        surveyThankYouURL = s.thankYouLink__c;
        surveyContainerCss = s.Survey_Container_CSS__c;
    }

    public List<SFQuestion> getAQuestion() {
        List<Survey_Question__c> allQuestionsObject = [
                Select s.Type__c, s.Id, s.Survey__c, s.Required__c, s.Question__c, s.OrderNumber__c, s.Name, s.Choices__c
                From Survey_Question__c s
                WHERE s.Survey__c = :surveyId
                ORDER BY s.OrderNumber__c
        ];
        allQuestions = new List<SFQuestion>();
        Double old_OrderNumber = 0;
        Double new_OrderNumber;
        Double difference = 0;
        for (Survey_Question__c q : allQuestionsObject) {
            new_OrderNumber = q.OrderNumber__c;
            difference = new_OrderNumber - old_OrderNumber - 1;
            if (difference > 0) {
                Double dd = double.valueOf(difference);
                Integer newOrderInt = dd.intValue();
                q.OrderNumber__c -= Integer.valueOf(newOrderInt);
            }
            old_OrderNumber = q.OrderNumber__c;
            SFQuestion theQ = new SFQuestion(q);
            allQuestions.add(theQ);
        }
        return allQuestions;
    }

    public void submitResults() {
        try {
            List <SurveyQuestionResponse__c> sqrList = new List<SurveyQuestionResponse__c>();
            for (SFQuestion q : allQuestions) {
                SurveyQuestionResponse__c sqr = new SurveyQuestionResponse__c();
                if (q.renderSelectRadio == 'true') {
                    if (q.required && (q.selectedOption == null || q.selectedOption == '')) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.BRC_Survey_Required_Field));
                        return;
                    }
                    if (q.selectedOption == null || q.selectedOption == '') {
                        sqr.Response__c = '';
                    } else {
                        sqr.Response__c = q.singleOptions.get(Integer.valueOf(q.selectedOption)).getLabel();
                    }
                    sqr.Survey_Question__c = q.Id;
                    sqrList.add(sqr);
                } else if (q.renderFreeText == 'true') {
                    if (q.required && q.choices == '') {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.BRC_Survey_Required_Field));
                        return;
                    }
                    sqr.Response__c = q.choices;
                    sqr.Survey_Question__c = q.Id;
                    sqrList.add(sqr);
                } else if (q.renderSelectCheckboxes == 'true') {
                    if (q.required && (q.selectedOptions == null || q.selectedOptions.size() == 0)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.BRC_Survey_Required_Field));
                        return;
                    }
                    for (String opt : q.selectedOptions) {
                        sqr = new SurveyQuestionResponse__c();
                        if (opt == '' || opt == null) {
                            sqr.Response__c = '';
                        } else {
                            sqr.Response__c = q.multiOptions.get(Integer.valueOf(opt)).getLabel();
                        }
                        sqr.Survey_Question__c = q.Id;
                        sqrList.add(sqr);
                    }
                } else if (q.renderSelectRow == 'true') {
                    if (q.required && (q.selectedOption == null || q.selectedOption == '')) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.BRC_Survey_Required_Field));
                        return;
                    }
                    if (q.selectedOption == null || q.selectedOption == '') {
                        sqr.Response__c = '';
                    } else {
                        sqr.Response__c = q.rowOptions.get(Integer.valueOf(q.selectedOption)).getLabel();
                    }
                    sqr.Survey_Question__c = q.Id;
                    sqrList.add(sqr);
                }
            }
            acceptJoin = sqrList.get(0).Response__c;

            if (AddSurveyTaker()) {
                for (SurveyQuestionResponse__c sqr : sqrList) {
                    sqr.SurveyTaker__c = surveyTakerId;
                }
                insert sqrList;
                thankYouRendered = true;
            }
        } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
        }
    }

    private Boolean AddSurveyTaker() {
        if (surveyId == null) {
            return false;
        }
        SurveyTaker__c st = new SurveyTaker__c();
        st.Name = surveyName;
        st.Lead__c = leadId;
        st.Survey__c = surveyId;
        st.Taken__c = acceptJoin;
        insert st;
        surveyTakerId = st.Id;
        return true;
    }
}