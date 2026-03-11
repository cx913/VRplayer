import AVFoundation
import SceneKit
import UIKit

enum VREye {
    case left
    case right
}

struct VRSceneFactory {
    static func makeScene(
        player: AVPlayer,
        settings: PlayerSettings,
        eye: VREye,
        yaw: Double,
        pitch: Double,
        roll: Double
    ) -> SCNScene {
        let scene = SCNScene()

        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.fieldOfView = 90
        cameraNode.eulerAngles = SCNVector3(-Float(pitch), Float(yaw), Float(roll))
        scene.rootNode.addChildNode(cameraNode)

        let contentNode = geometryNode(for: settings.projectionMode)
        let material = SCNMaterial()
        material.diffuse.contents = player
        material.isDoubleSided = true
        material.cullMode = .front
        material.lightingModel = .constant
        material.diffuse.contentsTransform = textureTransform(for: settings, eye: eye)
        material.diffuse.wrapS = .clamp
        material.diffuse.wrapT = .clamp
        contentNode.geometry?.firstMaterial = material

        scene.rootNode.addChildNode(contentNode)
        return scene
    }

    private static func geometryNode(for projection: ProjectionMode) -> SCNNode {
        switch projection {
        case .flat:
            let plane = SCNPlane(width: 5, height: 3)
            let node = SCNNode(geometry: plane)
            node.position = SCNVector3(0, 0, -4)
            return node
        case .vr180:
            let sphere = SCNSphere(radius: 10)
            sphere.segmentCount = 96
            let node = SCNNode(geometry: sphere)
            node.scale = SCNVector3(-1, 1, 1)
            return node
        case .vr360:
            let sphere = SCNSphere(radius: 10)
            sphere.segmentCount = 144
            let node = SCNNode(geometry: sphere)
            node.scale = SCNVector3(-1, 1, 1)
            return node
        }
    }

    private static func textureTransform(for settings: PlayerSettings, eye: VREye) -> SCNMatrix4 {
        var transform = CATransform3DIdentity

        switch settings.stereoMode {
        case .mono:
            break
        case .sbs:
            transform = CATransform3DScale(transform, 0.5, 1.0, 1)
            if eye == .right { transform = CATransform3DTranslate(transform, 1.0, 0, 0) }
        case .topBottom:
            transform = CATransform3DScale(transform, 1.0, 0.5, 1)
            if eye == .right { transform = CATransform3DTranslate(transform, 0, 1.0, 0) }
        }

        if settings.horizontalFlip {
            transform = CATransform3DScale(transform, -1, 1, 1)
            transform = CATransform3DTranslate(transform, -1, 0, 0)
        }

        if settings.verticalFlip {
            transform = CATransform3DScale(transform, 1, -1, 1)
            transform = CATransform3DTranslate(transform, 0, -1, 0)
        }

        return SCNMatrix4FromMat4(SCNMatrix4MakeFromCATransform3D(transform))
    }
}


private func SCNMatrix4MakeFromCATransform3D(_ t: CATransform3D) -> simd_float4x4 {
    simd_float4x4(
        SIMD4(Float(t.m11), Float(t.m12), Float(t.m13), Float(t.m14)),
        SIMD4(Float(t.m21), Float(t.m22), Float(t.m23), Float(t.m24)),
        SIMD4(Float(t.m31), Float(t.m32), Float(t.m33), Float(t.m34)),
        SIMD4(Float(t.m41), Float(t.m42), Float(t.m43), Float(t.m44))
    )
}
