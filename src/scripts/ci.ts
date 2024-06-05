import {getService} from "./api/getService";
import {createVersion} from "./api/createVersion";
import {listVCLFiles} from "./api/listVCLFiles";
import {getBuiltVCL} from "./utils/getBuiltVCL";
import {createVCLFile} from "./api/createVCLFile";
import {updateVCLFile} from "./api/updateVCLFile";
import {activateVersion} from "./api/activateVersion";

const VCL_FILE_NAME = 'fingerprint-pro-fastly-vcl';

async function main() {
    try {
        let service = await getService();
        const versionsSorted = service.versions.sort((a, b) => b.number - a.number);
        const lastVersion = versionsSorted.length > 0 ? versionsSorted[0] : undefined;
        let versionNumber;
        if (lastVersion.active) {
            console.log('active version found', lastVersion.number);
            const version = await createVersion(lastVersion.number);
            versionNumber = version.number;
            console.log('created draft version', versionNumber);
        }
        if (!versionNumber) {
            console.log('version not found creating...')
            const version = await createVersion();
            versionNumber = version.number;
            console.log('version created', versionNumber);
        }
        const vclFiles = await listVCLFiles(versionNumber);
        const vclFileToUpdate = vclFiles.find(t => t.name === VCL_FILE_NAME);
        console.log('searched for vcl files, found', vclFileToUpdate ? 'yes' : 'no')
        const builtVCLFile = await getBuiltVCL();
        if (!vclFileToUpdate) {
            await createVCLFile(VCL_FILE_NAME, versionNumber, builtVCLFile);
            console.log('created vcl file')
        } else {
            await updateVCLFile(VCL_FILE_NAME, versionNumber, builtVCLFile)
            console.log('updated vcl file')
        }
        console.log('activating new version', versionNumber)
        await activateVersion(versionNumber);
        console.log('activated version', versionNumber)
    } catch (e) {
        console.error(e)
    }
}

void main()
