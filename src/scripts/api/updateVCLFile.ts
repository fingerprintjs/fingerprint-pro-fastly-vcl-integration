import {createClient} from "../utils/createClient";

export async function updateVCLFile(name: string, versionNumber: number, content: string) {
    return createClient('vcl').updateCustomVcl({
        service_id: process.env.FASTLY_SERVICE_ID,
        version_id: versionNumber,
        vcl_name: name,
        content: content,
    })
}