//
//  ContentView.swift
//  Payroll
//
//  Created by Mario Tovar on 10/2/25.
//

import SwiftUI

struct ContentView: View {
    let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown Device ID"
    @State private var employeeID: Int = 0
    init(){
        if let savedID = UserDefaults.standard.value(forKey: "emloyeeID") as? Int {
            employeeID = savedID
            print("Employee ID found: \(employeeID)")
        } else {
            let newId = Int.random(in: 1000...9999)
            UserDefaults.standard.set(newId, forKey: "emloyeeID")
            employeeID = newId
            print("Employee ID not found, creating...")
            print("New Employee ID: \(employeeID)")
        }
    }
    var body: some View {
        VStack(spacing: 8) {
            
            // DeviceID
            Text("Device ID: \(deviceID)")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.bottom, 20)
            // EmployeeID
            Text("Employee ID: \(employeeID)")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.bottom, 20)
            Button(action: {
                clockEvent()
            }) {
                Text("Clock In")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Button(action: {
                print("Clock Out button pressed!")
            }) {
                Text("Clock Out")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
    // 67
    func clockEvent() {
        guard let url = URL(string: "https://avkicrmwbf.execute-api.us-west-1.amazonaws.com/default/clockIn") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let error = error{
                print("Error: ", error.localizedDescription)
                return
            }
            if let data = data, let responseText = String(data: data, encoding: .utf8) {
                print("Lambda response:", responseText)
            }
        }.resume()
    }
}

#Preview {
    ContentView()
}
