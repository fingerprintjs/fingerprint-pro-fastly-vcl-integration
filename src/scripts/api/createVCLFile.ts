import {createClient} from "../utils/createClient";

export async function createVCLFile(name: string, versionNumber: number, content: string) {
    return createClient('vcl').createCustomVcl({
        service_id: process.env.FASTLY_SERVICE_ID,
        version_id: versionNumber,
        name,
        content: content,
    })
}