import {createClient} from "../utils/createClient";

export async function listVCLFiles(versionNumber: number) {
    return createClient('vcl').listCustomVcl({
        service_id: process.env.FASTLY_SERVICE_ID,
        version_id: versionNumber,
    })
}