import DeviceCheck

protocol AttestationProvider {
    var isSupported: Bool { get }
}

extension DCAppAttestService: AttestationProvider {

}
