//
//  ReferenceTests.swift
//  SwiftFHIR
//
//  Created by Pascal Pfiffner on 11/30/15.
//  2016, SMART Health IT.
//

import XCTest
#if !NO_MODEL_IMPORT
import Models
import Client
//import ModelTests
#else
import SwiftFHIR
#endif


/**
Test reference resolving.
*/
class ReferenceTests: XCTestCase {
	
	func testContainedReference() {
		do {
			let json = try readJSONFile("ReferenceContained1.json", directory: testResourcesDirectory)
			let order1 = try MedicationRequest(json: json)
			XCTAssertEqual("order-ref-contained", order1.id)
			XCTAssertNotNil(order1.medicationReference)
			XCTAssertEqual("Red Pill", order1.medicationReference?.resolved(Medication.self)?.code?.text ?? "missing")
			XCTAssertEqual("Red Pill", order1.medicationReference?.resolved(Medication.self)?.code?.text ?? "missing")		// second time, reading from `_resolved`
			XCTAssertEqual("Morpheus Co.", order1.medicationReference?.resolved(Medication.self)?.manufacturer?.resolved(Organization.self)?.name)
		}
		catch {
			XCTAssertTrue(false, "\(error)")
		}
		
		do {
			let json = try readJSONFile("ReferenceContained2.json", directory: testResourcesDirectory)
			let order1 = try MedicationRequest(json: json)
			XCTAssertEqual("order-ref-contained-wrong", order1.id)
			XCTAssertNotNil(order1.medicationReference)
			XCTAssertNil(order1.medicationReference?.resolved(Medication.self), "Must not resolve contained resource with wrong type")
			XCTAssertNil(order1.medicationReference?.resolved(Medication.self), "Must still not resolve contained resource with wrong type")		// second time, reading from `_resolved`
			XCTAssertEqual("Morpheus Co.", order1.medicationReference?.resolved(Organization.self)?.name)
		}
		catch {
			XCTAssertTrue(false, "\(error)")
		}
	}
	
	func testBundledReference() {
		do {
			let json = try readJSONFile("ReferenceBundled.json", directory: testResourcesDirectory)
			let bundle = try Bundle(json: json)
			XCTAssertEqual("Bundle", type(of: bundle).resourceType)
			
			// get resources
			let pat23 = bundle.entry?[0].resource as! Patient
			XCTAssertEqual("Patient", type(of: pat23).resourceType)
			XCTAssertEqual("Darth", pat23.name?[0].given?[0])
			let patURN = bundle.entry?[1].resource as! Patient
			XCTAssertEqual("Patient", type(of: patURN).resourceType)
			XCTAssertEqual("Ben", patURN.name?[0].given?[0])
			let obs123 = bundle.entry?[2].resource as! Observation
			XCTAssertEqual("Observation", type(of: obs123).resourceType)
			XCTAssertEqual("123", obs123.id)
			let obs56 = bundle.entry?[3].resource as! Observation
			XCTAssertEqual("Observation", type(of: obs56).resourceType)
			XCTAssertEqual("56", obs56.id)
			let obs34 = bundle.entry?[4].resource as! Observation
			XCTAssertEqual("Observation", type(of: obs34).resourceType)
			XCTAssertEqual("34", obs34.id)
			
			// test resolving
			bundle._server = FHIROpenServer(baseURL: URL(string: "https://fhir.smarthealthit.org")!)
			let res1 = obs123.subject!.resolved(Patient.self)      // relative reference, bundled
			XCTAssertTrue(res1 === pat23)
			let res2 = obs123.subject!.resolved(Medication.self)
			XCTAssertNil(res2, "Must not resolve on type mismatch")
			
			let res3 = obs56.subject!.resolved(Patient.self)       // bundled, URN-referenced
			XCTAssertTrue(res3 === patURN)
			
			/* TODO: this does resolve now, update test
			let readyExpectation = expectation(withDescription: "absolute")
			obs34!.subject!.resolve(Patient.self) { pat in          // absolute reference, on same server but different endpoint
				XCTAssertNil(pat, "Must not resolve Patient on same server but different endpoint")
				readyExpectation.fulfill()
			}
			waitForExpectations(withTimeout: 1) { error in
				XCTAssertNil(error, "Should return immediately")
			}	//	*/
		}
		catch {
			XCTAssertTrue(false, "\(error)")
		}
	}
	
//	func testRelativeReference() {
//		do {
//			let json = try readJSONFile("ReferenceRelative.json", directory: testResourcesDirectory)
//			let order1 = try MedicationRequest(json: json)
//			XCTAssertEqual("order-ref-relative", order1.id)
//			XCTAssertEqual("Medication/med-1234", order1.medicationReference?.reference)
//			XCTAssertNil(order1.medicationReference?.resolved(Medication.self), "Cannot already be resolved")
//			
//			let readyExpectation = expectation(description: "reference")
//			order1.medicationReference?.resolve(Medication.self) { medication in
//				XCTAssertNil(medication, "Resolving must be impossible without server instance")
//				readyExpectation.fulfill()
//			}
//			waitForExpectations(timeout: 1) { error in
//				XCTAssertNil(error, "Should return immediately")
//			}
//		}
//		catch {
//			XCTAssertTrue(false, "\(error)")
//		}
//	}
//	
//	func testAbsoluteReference() {
//		do {
//			let json = try readJSONFile("ReferenceAbsolute.json", directory: testResourcesDirectory)
//			let order1 = try MedicationRequest(json: json)
//			XCTAssertEqual("order-ref-absolute", order1.id)
//			XCTAssertEqual("https://fhir-open-api-dstu2.smarthealthit.org/Medication/1", order1.medicationReference?.reference)
//			XCTAssertNil(order1.medicationReference?.resolved(Medication.self), "Cannot already be resolved")
//			
//			let readyExpectation = expectation(description: "reference")
//			order1.medicationReference?.resolve(Medication.self) { medication in
//				XCTAssertNil(medication, "Unfortunately, don't currently have Medication/1 on the SMART server")
//				readyExpectation.fulfill()
//			}
//			waitForExpectations(timeout: 5) { error in
//				XCTAssertNil(error, "Error resolving reference")
//			}
//		}
//		catch {
//			XCTAssertTrue(false, "\(error)")
//		}
//	}
}

