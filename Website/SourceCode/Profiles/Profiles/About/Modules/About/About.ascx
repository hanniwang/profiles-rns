<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="About.ascx.cs" Inherits="Profiles.About.Modules.About.About" %>
<div class="pageTabs">
    <asp:Literal runat="server" ID="litTabs"></asp:Literal>
</div>
<div class="aboutText">
    <asp:Panel runat="server" ID="pnlOverview" Visible="false">
        <table>
            <tr>
                <td>
                    <h3>
                        Introduction</h3>
                    <p>
                        Profiles Research Networking Software (UAMS Profiles RNS) is a networking tool designed to help researchers at UAMS more easily connect with each other through common interests, projects, and specialties. Profiles goes beyond a traditional directory to not only show traditional directory information, but it also illustrates how each person is connected to others in the broad research community.
                    </p>
                    <p>
                        As you navigate through the website, you will see three types of pages:
                    </p>
                    <p>
                        <asp:Image runat="server" ID="imgProfilesIcon"></asp:Image>
                        <u>Profile Pages</u>
                        <div style="padding-left: 15px">
                            Each person has a Profile Page that includes biographical information such as name, titles, affiliations, and contact information. Faculty can edit their own profiles, adding publications, awards, narrative, and a photo. 
                        </div>
                        <br />
                        <div style="padding-left: 15px">
                            Included on each person's Profile Page is a list of their Networks. Networks are formed automatically when researchers share common traits such as being in the same department, working in the same building, co-authoring the same paper, or researching the same concepts or topics. A preview of a person's passive networks is shown on the right side of his or her profile.   
                        </div>
                    </p>
                    <br />
                    <p>
                        <asp:Image runat="server" ID="imgNetworkIcon" />
                        <u>Network Pages</u><br />
                        <div style="padding-left: 15px">
                            Network Pages show all the people in a particular Network. Networks are not restricted to just people, networks can be comprised of other information from the database as well. A "concept" network is a list of all the topics a person has written about. 
                        </div>
                        <br />
                         <div style="padding-left: 15px">
                            Profiles includes several different ways to view networks, including (from left to right) Concept Clouds, which highlight a person's areas of research; Map Views, which show where a person's co-authors are located; Publication Timelines, which graph the number of publications of different types by year; Radial Network Views, which illustrate clusters of connectivity among related people; and Concept Timelines, which depict how a person's research focus has changed over time.
                        </div>
                        <p>
                        <div align="center">
                            <asp:Image runat="server" ID="imgVis" />
                        </div>
                    </p>
                    </p>
                    <p>
                        <asp:Image runat="server" ID="imgConnectionIcon" />
                        <u>Connection Pages</u><br />
                        <div style="padding-left: 15px">
                            Certain Network Pages will include a "Why?" link. These will take you to a Connection Page, which shows why two people or profiles in that network are connected. For example, the Why link in a co-authorship network lists the publications that two people wrote together. The Connection Pages also reveal why certain people appear higher on search results and why particular concepts are highlighted on a person's profile.
                        </div>
                    </p>
                                        
                    <h3>
                        Sharing Data</h3>
                    <p>
                        Profiles is a Semantic Web application, which means its content
                        can be read and understood by other computer programs. This enables the data in
                        profiles, such as addresses and publications, to be shared with other institutions
                        and appear on other websites. If you click the "Export RDF" link on the left sidebar
                        of a profile page, you can see what computer programs see when visiting a profile.
                        For technical information about how build a computer program that can export data
                        from Profiles Research Networking Software, view the <a href="?tab=data">Sharing Data</a> page.
                    </p>
                </td>
            </tr>
        </table>
    </asp:Panel>
    <asp:Panel runat="server" ID="pnlFAQ" Visible="false">
        <h3>
            How was my profile created?
        </h3>
        <p>
            All profiles were created using information from the UAMS FacFacts (Faculty Facts) faculty database, PubMed, TRACKS, and SAP. <!--More information about FactFacts can be found here: <a href="http://medicine.uams.edu/faculty/faculty-databases/facfacts/">http://medicine.uams.edu/faculty/faculty-databases/facfacts/</a>-->
        </p>

        <h3>
           Who is listed on UAMS Profiles RNS?
        </h3>
        <p>
            All faculty members and post-doc researchers are listed in Profiles RNS. Additionally, manual additions of profiles can be performed through the Profiles RNS website, but that power is limited to administrative users.
        </p>

        <h3>
            Who has access to UAMS Profiles RNS?
        </h3>
        <p>
            Currently, Profiles is open access within the UAMS network, but not searchable. Meaning anyone who knows about the webpage can access it, provided they are logged into the UAMS network.  
        </p>

        <h3>
            Do I need to login to UAMS Profiles RNS?
        </h3>
        <p>
            Most Profiles capabilities can be accessed without logging in. Login is only required if you want to edit your profile. As a reminder, though, you will need to be logged into the UAMS network for access. 
            <ul>
                <li>Go to <a href="http://prfportal.uams.edu/profiles">http://prfportal.uams.edu/profiles</a></li>
                <li>This will automatically take you to the search screen where you can search for people or terms.</li>
            </ul>
        </p>
        <h3>
            UAMS Profiles RNS has been integrated into the UAMS network, so all you need to login is your UAMS ID and password. 
        </h3>
            <p>To login to Profiles RNS:
                <ul>
                    <!--<li>Go to <a href="http://prfportal.uams.edu/">http://prfportal.uams.edu/</a></li>-->
                    <li>Click on the "Login to Profiles" tab in the navigation bar at the top of the screen</li>
                    <li>Login with your UAMS ID and password</li>
                    <li>Once you login it should automatically direct you back to the main UAMS Profiles RNS search page</li>
                    <li>If you would like to view your personal profile, click the "View My Profile" tab in the navigation bar at the top of the screen</li>
                    <li>If you would like to edit your personal profile, click the “edit My Profile” tab in the navigation bar at the top of the screen. This will take you to the edit page for your profile </li>
                </ul>
            </p>
                  
            <p>If you do not have a UAMS Profiles RNS account you will not be able to log into Profiles, even if you do have a UAMS ID. For assistance with this, please see <a href="#contact"><i>Who do I contact for more information or questions?</i></a></p>

         <h3>
           How do I view my profile?
        </h3>
        <p>
            To view your profile, click the View My Profile tab in the Navigation Menu at the top of the screen.  
        </p>

        <h3>
           When are profiles for new faculty/post-doc researchers added to Profiles RNS? 
        </h3>
        <p>
           Profiles relies on FacFacts to populate its demographic data. Once a new faculty member/post –doc’s appointment has been entered into faculty affairs into FacFacts it will be added to Profiles RNS via its next update. Profiles RNS updates its FacFacts information monthly.  
        </p>

         <h3>
            How do I edit my profile? 
        </h3>
        <p>
            To edit your profile, click the "Edit My Profile" link in the Navigation Menu. You might be prompted to login. The Edit Menu page lists all the types of content that can be included on your profile. They are grouped into categories and listed in the same order as they appear when viewing your profile. Click any content type to view/edit the items or change the privacy settings. 
        </p>
        <p>
            Note: Some types of content are imported automatically from other systems, and cannot be edited through UAMS Profiles RNS and will appear with a "locked" icon. Biographical data such as affiliation, title, mailing address, and email address are all locked as they are populated from your Human Resources record and maintained separately in that system. 
        </p>

         <h3>
            Why are there missing or incorrect publications in my profile?
        </h3>
        <p>
           Publications are added both automatically from PubMed and manually by faculty themselves. Unfortunately, there is no easy way to match articles in PubMed to the profiles on this website. The algorithm used to find articles from PubMed attempts to minimize the number of publications incorrectly added to a profile; however, this method results in some missing publications as well as the addition of publications that may not be yours. Faculty with common names or whose articles were written at other institutions are most likely to have incomplete lists or inaccurate publications listed. We encourage all faculty to login to the website and add any missing publications or remove incorrect ones. 
        </p>

         <h3>
            Can I edit my concepts, co-authors, or list of similar people?
        </h3>
        <p>
            These are derived automatically from the PubMed articles listed with your profile. You cannot edit these directly, but you can improve these lists by keeping your publications up to date. Please note that it takes up to 24 hours for the system to update your concepts, co-authors, and similar people after you have modified your publications. Concept rankings and similar people lists are based on algorithms that weigh multiple factors, such as how many publications you have in a subject area compared to the total number of faculty who have published in that area. Your feedback is essential to helping us refine these algorithms.  
        </p>

         <h3>
            What are the Networks to the right side of my screen? 
        </h3>
        <p>
            The lists to the right of your screen are your Networks. These networks are populated automatically by the system and reflect people that share common traits such as research focus, article authorship, departments, etc. Most networks are populated using a person's publication history. The Concepts Network is organized into and derived using a series of Medical Subject Headings (MeSH) terms used by the National Library of Medicine (NLM). Terms that are present within a person's publications will appear under their Concepts Network. If you click the link to each concept, you can learn more about what each term means (the official NLM definition) and see the history of its prevalence in the medical community. The Similar People Network is derived in much the same way and links people that have the MESH terms in common. The Co-Authors Network is simply a list of authors each person has worked with on his or her listed publications. Department lists are determined automatically through other records and consist of people in each person's home department at UAMS.
        </p>

         <h3>
            What are the system requirements for accessing UAMS Profiles RNS?
        </h3>
        <p>
            The only thing needed to access UAMS Profiles RNS is an internet capable computer with a modern web browser.  
        </p>

         <h3>
           Who Created Profiles Research Networking Software? 
        </h3>
        <p>
            This service is made possible by the Profiles Research Networking Software developed under the supervision of Griffin M Weber, MD, PhD, with support from Grant Number 1 UL1 RR025758-01 to Harvard Catalyst: The Harvard Clinical and Translational Science Center from the National Center for Research Resources and support from Harvard University and its affiliated academic healthcare centers. 
        </p>

         <h3 id="contact">
            Who do I contact for more information or questions?
        </h3>
        <p>
            For more information or questions, please contact <a href="mailto:DBMI@UAMS.EDU">DBMI</a>.
        </p>
    </asp:Panel>
    <asp:Panel runat="server" ID="pnlData" Visible="false">
        <h3>
            Sharing Data (Export RDF)</h3>
        <p>
            As a Semantic Web application, Profiles Research Networking Software uses the Resource Description
            Framework (RDF) data model. In RDF, every entity (e.g., person, publication, concept)
            is given a unique URI. (A URI is similar to a URL that you would enter into a web
            browser.) Entities are linked together using "triples" that contain three URIs--a
            subject, predicate, and object. For example, the URI of a Person can be connected
            to the URI of a Concept through a predicate URI of hasResearchArea. Profiles Research 
            Networking Software contains millions of URIs and triples. Semantic Web applications use an
            ontology, which describes the classes and properties used to define entities and
            link them together. Profiles Research Networking Software uses the VIVO Ontology, which was
            developed as part of an NIH-funded grant to be a standard for academic and research
            institutions. A growing number of sites around the world are adopting research networking
            platforms that use the VIVO Ontology. Because RDF can link different triple-stores
            that use the same ontology, software developers are able to create tools that span
            multiple institutions and data sources. When RDF data is shared with the public,
            as it is in Profiles Research Networking Software, it is called Linked Open Data (LOD).
        </p>
        <p>
            There are four types of application programming interfaces (APIs) in Profiles Research 
            Networking Software.
        </p>
        <ul>
            <li>RDF crawl. Because Profiles Research Networking Software is a Semantic Web application, every
                profile has both an HTML page and a corresponding RDF document, which contains the
                data for that page in RDF/XML format. Web crawlers can follow the links embedded
                within the RDF/XML to access additional content.</li>
            <li>SPARQL endpoint. SPARQL is a programming language that enables arbitrary queries
                against RDF data. This provides the most flexibility in accessing data; however,
                the downsides are the complexity in coding SPARQL queries and performance. In general,
                the XML Search API (see below) is better to use than SPARQL.
            <li>XML Search API. This is a web service that provides support for the most common
                types of queries. It is designed to be easier to use and to offer better performance
                than SPARQL, but at the expense of fewer options. It enables full-text search across
                all entity types, faceting, pagination, and sorting options. The request message
                to the web service is in XML format, but the output is in RDF/XML format. 
            <li>Old XML based web services. This provides backwards compatibility for institutions
                that built applications using the older version of Profiles Research Networking Software. These
                web services do not take advantage of many of the new features of Profiles Research 
                Networking Software. Users are encouraged to switch to one of the new APIs.
        </ul>
        <p>
            For more information about the APIs, please see the <a href="http://profiles.catalyst.harvard.edu/docs/ProfilesRNS_1.0.3_APIGuide.pdf">
                documentation</a> and <a href="http://profiles.catalyst.harvard.edu/docs/ProfilesRNS_1.0.3_API_Examples.zip">
                    example files</a>.
        </p>
    </asp:Panel>
     <asp:Panel runat="server" ID="pnlDev" Visible="false">
        <h3>
           Development
        </h3>
        <p>
           Profiles was first envisioned and created as a CTSA funded project by Harvard Catalyst, Harvard University's Clinical and translational Science Center. Considered ground-breaking by many in the field, Profiles has spread to other universities and colleges across the US who have developed their own form of the tool. These various institutions work together as one larger Profiles family to continue to grow and improve upon the program.
        </p>
         <p>
           UAMS Profiles RNS has been developed and is maintained by UAMS' Translational Research Institute and the Division of Biomedical Informatics. Specific acknowledgements are listed below.
        </p>

         <h3>
           Sponsors:
        </h3>
        <p>
           The adoption and development of Profiles RNS at the University of Arkansas for Medical Sciences (UAMS) is supported by the Translational Research Institute (TRI) funded by the National Institutes of Health (NIH) Clinical and Translational Science Award (CTSA) program.
        </p>

         <h3>
           Acknowledgements:
        </h3>
        <p>
           This service is made possible by the Profiles Research Networking Software developed under the supervision of Griffin M Weber, MD, PhD, with support from Grant Number 1 UL1 RR025758-01 to Harvard Catalyst: The Harvard Clinical and Translational Science Center from the National Center for Research Resources and support from Harvard University and its affiliated academic healthcare centers.
        </p>
        
     </asp:Panel>
</div>
