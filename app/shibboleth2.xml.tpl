<SPConfig xmlns="urn:mace:shibboleth:3.0:native:sp:config"
    xmlns:conf="urn:mace:shibboleth:3.0:native:sp:config"
    clockSkew="180">

    <OutOfProcess tranLogFormat="%u|%s|%IDP|%i|%ac|%t|%attr|%n|%b|%E|%S|%SS|%L|%UA|%a" />
  
    <!--
    By default, in-memory StorageService, ReplayCache, ArtifactMap, and SessionCache
    are used. See example-shibboleth2.xml for samples of explicitly configuring them.
    -->

    <!-- The ApplicationDefaults element is where most of Shibboleth's SAML bits are defined. -->
    <ApplicationDefaults entityID="<ENTITY_ID>"
        REMOTE_USER="eppn subject-id pairwise-id persistent-id"
        cipherSuites="DEFAULT:!EXP:!LOW:!aNULL:!eNULL:!DES:!IDEA:!SEED:!RC4:!3DES:!kRSA:!SSLv2:!SSLv3:!TLSv1:!TLSv1.1">

        <!--
        Controls session lifetimes, address checks, cookie handling, and the protocol handlers.
        Each Application has an effectively unique handlerURL, which defaults to "/Shibboleth.sso"
        and should be a relative path, with the SP computing the full value based on the virtual
        host. Using handlerSSL="true" will force the protocol to be https. You should also set
        cookieProps to "https" for SSL-only sites. Note that while we default checkAddress to
        "false", this makes an assertion stolen in transit easier for attackers to misuse.
        -->
        <Sessions lifetime="28800" timeout="3600" relayState="ss:mem"
                  checkAddress="false" handlerSSL="false" cookieProps="<SHIB_SCHEME>">

            <!--
            Configures SSO for a default IdP. To properly allow for >1 IdP, remove
            entityID property and adjust discoveryURL to point to discovery service.
            You can also override entityID on /Login query string, or in RequestMap/htaccess.
            -->
            <SSO entityID="<IDP_ENTITY_ID>">
              SAML2
            </SSO>

            <!-- SAML and local-only logout. -->
            <Logout>SAML2 Local</Logout>

            <!-- Administrative logout. -->
            <LogoutInitiator type="Admin" Location="/Logout/Admin" acl="127.0.0.1 ::1" />
          
            <!-- Extension service that generates "approximate" metadata based on SP configuration. -->
            <Handler type="MetadataGenerator" Location="/Metadata" signing="false"/>

            <!-- Status reporting service. -->
            <Handler type="Status" Location="/Status" acl="127.0.0.1 ::1"/>

            <!-- Session diagnostic service. -->
            <Handler type="Session" Location="/Session" showAttributeValues="false"/>

            <!-- JSON feed of discovery information. -->
            <Handler type="DiscoveryFeed" Location="/DiscoFeed"/>
        </Sessions>

        <!--
        Allows overriding of error template information/filenames. You can
        also add your own attributes with values that can be plugged into the
        templates, e.g., helpLocation below.
        -->
        <Errors supportContact="<SUPPORT_CONTACT>"
            helpLocation="/about.html"
            styleSheet="/shibboleth-sp/main.css"/>

        <!-- Example of locally maintained metadata. -->
        <!--
        <MetadataProvider type="XML" validate="true" path="partner-metadata.xml"/>
        -->

        <!-- Example of remotely supplied batch of signed metadata. -->
        <!--
        <MetadataProvider type="XML" validate="true"
	            url="http://federation.org/federation-metadata.xml"
              backingFilePath="federation-metadata.xml" maxRefreshDelay="7200">
            <MetadataFilter type="RequireValidUntil" maxValidityInterval="2419200"/>
            <MetadataFilter type="Signature" certificate="fedsigner.pem" verifyBackup="false"/>
            <DiscoveryFilter type="Blacklist" matcher="EntityAttributes" trimTags="true" 
              attributeName="http://macedir.org/entity-category"
              attributeNameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:uri"
              attributeValue="http://refeds.org/category/hide-from-discovery" />
        </MetadataProvider>
        -->

        <!-- Example of remotely supplied "on-demand" signed metadata. -->
        <!--
        <MetadataProvider type="MDQ" validate="true" cacheDirectory="mdq"
	            baseUrl="http://mdq.federation.org" ignoreTransport="true">
            <MetadataFilter type="RequireValidUntil" maxValidityInterval="2419200"/>
            <MetadataFilter type="Signature" certificate="mdqsigner.pem" />
        </MetadataProvider>
        -->

        <!-- Map to extract attributes from SAML assertions. -->
        <AttributeExtractor type="XML" validate="true" reloadChanges="false" path="attribute-map.xml"/>

        <!-- Default filtering policy for recognized attributes, lets other data pass. -->
        <AttributeFilter type="XML" validate="true" path="attribute-policy.xml"/>

        <!-- Simple file-based resolvers for separate signing/encryption keys. -->
        <CredentialResolver type="File" key="sp-key.pem" certificate="sp-cert.pem" /> 
        
    </ApplicationDefaults>
    
    <!-- Policies that determine how to process and authenticate runtime messages. -->
    <SecurityPolicyProvider type="XML" validate="true" path="security-policy.xml"/>

    <!-- Low-level configuration about protocols and bindings available for use. -->
    <ProtocolProvider type="XML" validate="true" reloadChanges="false" path="protocols.xml"/>

</SPConfig>
