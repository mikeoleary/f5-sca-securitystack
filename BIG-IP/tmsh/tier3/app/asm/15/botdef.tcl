security log profile /Common/bennlog {
    application {
        /Common/bennlog {
            filter {
                log-challenge-failure-requests {
                    values { enabled }
                }
                request-type {
                    values { all }
                }
            }
            response-logging illegal
        }
    }
    bot-defense {
        /Common/bennlog {
            filter {
                log-alarm enabled
                log-block enabled
                log-browser enabled
                log-browser-verification-action enabled
                log-captcha enabled
                log-challenge-failure-request enabled
                log-device-id-collection-request enabled
                log-honey-pot-page enabled
                log-malicious-bot enabled
                log-mobile-application enabled
                log-none enabled
                log-rate-limit enabled
                log-redirect-to-pool enabled
                log-suspicious-browser enabled
                log-tcp-reset enabled
                log-trusted-bot enabled
                log-unknown enabled
                log-untrusted-bot enabled
            }
            local-publisher /Common/local-db-publisher
        }
    }


security bot-defense profile /Common/nyan {
    allow-browser-access enabled
    api-access-strict-mitigation enabled
    app-service none
    blocking-page {
        body "<html><head><title>Request Rejected</title></head><body>The requested URL was rejected. Please consult with your administrator.<br><br>Your support ID is: <%BOTDEFENSE.support_id%><br><br><a href='javascript:history.back();'>[Go Back]</body></html>"
        headers "Cache-Control: no-store, must-revalidate, no-cache Pragma: no-cache Connection: close"
        status-code 200
        type default
    }
    browser-mitigation-action block
    captcha-response {
        failure {
            body "You have entered an invalid answer for the question. Please, try again. <br> %BOTDEFENSE.captcha.image% %BOTDEFENSE.captcha.change% <br> <b>What code is in the image\?</b> %BOTDEFENSE.captcha.solution% <br> %BOTDEFENSE.captcha.submit% <br> <br> Your support ID is: %BOTDEFENSE.captcha.support_id%."
            type default
        }
        first {
            body "This question is for testing whether you are a human visitor and to prevent automated spam submission. <br> %BOTDEFENSE.captcha.image% %BOTDEFENSE.captcha.change% <br> <b>What code is in the image\?</b> %BOTDEFENSE.captcha.solution% <br> %BOTDEFENSE.captcha.submit% <br> <br> Your support ID is: %BOTDEFENSE.captcha.support_id%."
            type default
        }
    }
    cross-domain-requests allow-all
    description none
    deviceid-mode generate-after-access
    dos-attack-strict-mitigation enabled
    enforcement-mode transparent
    enforcement-readiness-period 7
    grace-period 300
    honeypot-page {
        body <html><head><title></title></head><body></body></html>
        headers "Cache-Control: no-store, must-revalidate, no-cache Pragma: no-cache Connection: close"
        status-code 200
        type default
    }
    mobile-detection {
        allow-android-rooted-device disabled
        allow-any-android-package enabled
        allow-any-ios-package enabled
        allow-emulators disabled
        allow-jailbroken-devices disabled
        block-debugger-enabled-device enabled
        client-side-challenge-mode pass
    }
    perform-challenge-in-transparent disabled
    redirect-to-pool-name none
    signature-staging-upon-update disabled
    single-page-application disabled
    template relaxed
    whitelist {
        apple_touch_1 {
            match-order 2
            url /apple-touch-icon*.png
        }
        favicon_1 {
            match-order 1
            url /favicon.ico
        }
    }
}
