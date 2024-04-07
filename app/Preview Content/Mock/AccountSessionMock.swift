import Foundation

extension AccountSession {
    static var mock: AccountSession {
        AccountSession(
            user: .init(id: "b4778cd3-c832-45cd-8861-0d0b4a0ff226", email: "danilo@client.com", fullName: "Danilo Felipe"),
            token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJiNDc3OGNkMy1jODMyLTQ1Y2QtODg2MS0wZDBiNGEwZmYyMjYiLCJpYXQiOjE3MTIxNDkzNzQsImV4cCI6MTcxNDc0MTM3NH0.MmQxg-M1TOHlODsxoaFRi0swzjVCFsIG87M_JIfxXrI"
        )
    }
}
