// Abstract signature for Users
abstract sig User {}

// University Administrator
sig UniversityAdmin extends User {
    manages: set Match,
    handles: set Complaint
}

// Company Administrator
sig CompanyAdmin extends User {
    hasPosted: set Internship
}

// Student
sig Student extends User {
    hasApplied: set Internship,
    profileQuestionnaire: lone Questionnaire,
    feedback: set Feedback,
    recommendedList: set Recommendation,
    questionnaire: lone Questionnaire
}

// Internship
sig Internship {
    companyPost: one CompanyAdmin,
    studentApplication: set Student,
    matchCreated: set Match,
    recommendedList: some Recommendation
}

// Match
sig Match {
    isApproved: one Boolean,
    isApprovedBy: one UniversityAdmin,
    internship: one Internship,
    student: one Student,
    status: one MatchStatus,
    opens: lone Chat,
    interview: lone Interview,
    employer: one CompanyAdmin,
    complaint: set Complaint,
    monthlyFeedback: set Monthly,
    finalFeedback: lone Final
}

// Chat
sig Chat {
    belongsTo: one Match
}

// Enumeration for Match Status
enum MatchStatus { Ongoing, Closed, Chatting, Pending }
enum Boolean { True, False }

// Abstract Form
abstract sig Form {
    question: some Question
}

// Interview Form
sig Interview extends Form {
    match: one Match,
    usedIn: set Recommendation
}

// Questionnaire Form
sig Questionnaire extends Form {
    usedIn: set Recommendation,
    byStudent: one Student
}

// Feedback Form
abstract sig Feedback extends Form {
    usedIn: set Recommendation,
    match: one Match
}

// Monthly Feedback
sig Monthly extends Feedback {}

// Final Feedback
sig Final extends Feedback{}

// Complaint Form
sig Complaint extends Form {
    complaint: one Match,
    fromStudent: lone Student,
    fromCompany: lone CompanyAdmin,
    notified: one UniversityAdmin
}

// Recommendation
sig Recommendation {
    feedbackList: set Feedback,
    questionnaireList: set Questionnaire,
    interviewsList: set Interview,
    student: set Student,
    internship: set Internship
}

// Abstract Question
abstract sig Question {
    inForm: some Form
}

// Multiple Choice Question
sig MultipleChoice extends Question {}

// Open-Ended Question
sig OpenEnded extends Question {}





// An internship can only belong to one company
fact InternshipAdmin {
    all i: Internship | one i.companyPost
}

// A match must involve one student and one internship
fact MatchConstraint {
    all m: Match | one m.internship and one m.student
}

// A student cannot apply to the same internship multiple times
fact StudentApplication {
    all s: Student | all i: s.hasApplied | one i
}

// A student and an internship can only have one match
fact UniqueMatchPerInternshipStudent {
    all i: Internship, s: Student | lone m: Match | m.internship = i and m.student = s
    all i: Internship | all m: i.matchCreated | m.internship = i
}

// Constraints on Feedback and Match
fact Constraints {
    // For a final feedback to exist, the match status must be "closed"


all m: Match | m.finalFeedback != none implies (m.status = Closed and m.isApproved = True)
all m: Match | m.monthlyFeedback != none implies ((m.status = Ongoing or m.status = Closed) and m.isApproved = True)
}

// University Admin only manages approved matches
fact UniversityManagesApprovedMatches {
  all u: UniversityAdmin | all m: u.manages | m.isApproved = True
}



fact ChatNumer{
 all m: Match | #(m.opens) < 2
 all c1, c2: Chat | c1 != c2 implies c1.match != c2.match
}



//If a university approves a match, the student for whom the match is approved 
//belongs to that university.

fact BelongToUniversity {
    all m: Match | 
        m.isApproved = True implies 
        m.student in m.isApprovedBy.manages.student
}

// A company cannot post two identical internships
fact UniqueCompanyInternships {
  all c: CompanyAdmin | no disj i1, i2: c.hasPosted | i1 = i2
}

// A Complaint must have one and only one between Student and CompanyAdmin
fact ComplaintHasSingleAuthor {
  all c: Complaint | one c.fromStudent + c.fromCompany
all c: Complaint |  all m: c.complaint | m.isApproved = True and m.complaint = c
}

fact ongoingInternship{
	all m: Match | m.status = Ongoing implies m.isApproved = True
}

fact ComplaintStatusConstraint {
    all c: Complaint | all m: c.complaint | m.status = Ongoing or m.status = Closed
}

fact feedbackFromApprovedMatches{
all f: Feedback | all m: f.match | m.isApproved = True
}

fact QuestionnaireStudent{
all q: Questionnaire | all s: q.byStudent | s.questionnaire = q
}

fact RecommendationInternship{
all i: Internship | all r: i.recommendedList | r.internship = i
}






// Matches can only have one valid status at a time
assert ValidMatchStatus {
    all m: Match | one m.status
}


//Check that the final feedback exists only if the match is closed because the internship is over.
assert FinalFeedback{
all m: Match | m.finalFeedback != none implies m.status = Closed
}

//Check that a complaint must be filed either by a student or a company or both simultaneously.
assert ComplaintFile{
all c: Complaint | one c.fromStudent + c.fromCompany
}
//check ComplaintFile


//Check that statistics for a company must aggregate only feedback from closed internships.
assert ComplaintIsNotifiedToAdmin {
  all c: Complaint | one c.notified
}

//check ComplaintIsNotifiedToAdmin

assert StudentApplication{
all s: Student | all i: s.hasApplied | one i
}
//check StudentApplication


// PREDICATES

// Check if a student has applied for an internship
pred studentApplications(s: Student, i: Internship) {
    i in s.hasApplied
}
//run studentApplications

// Check if an internship is posted by a specific company
pred companyPostedInternships(c: CompanyAdmin, i: Internship) {
    i in c.hasPosted
}
//run companyPostedInternships

pred unresolvedComplaints(u: UniversityAdmin) {
    all c: Complaint |
    c.notified = u and c.complaint.status != Closed
}
//run unresolvedComplaints



//Predicate to check if an internship has any approved matches by a university admin

pred internshipHasApprovedMatches(i: Internship) {
  some m: Match | m.internship = i and m.isApproved = True
}
//run internshipHasApprovedMatches


pred monitorInternships(u: UniversityAdmin) {
    all m: Match | m.isApproved = True and m.isApprovedBy = u implies m.status = Ongoing
}
//run monitorInternships

// Check if the feedback status is closed correctly after the right feedbacks are completed
pred feedbackAggregation() {
     all m: Match |#(m.finalFeedback) > 0 implies m.status = Closed
}
//run feedbackAggregation

pred UniversityAdminManageOnlyApprovedMatches {
    all u: UniversityAdmin | 
        all m: u.manages | 
            m.isApproved = True implies m.isApprovedBy = u
}
//run UniversityAdminManageOnlyApprovedMatches

//A complaint must reference only the match it is associated with
pred matchComplaintConsistency(c: Complaint, m: Match) {
    c.complaint = m implies c.fromStudent = m.student or c.fromCompany = m.employer
}
run matchComplaintConsistency




