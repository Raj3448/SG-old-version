import 'package:silver_genie/feature/members/model/member_model.dart';

abstract class IMembersService {
  Future<List<Member>> getMembers();
  Future<void> addMember(Member member);
  Future<void> editMember(Member member);
}

class MockMemberService implements IMembersService {
  @override
  Future<List<Member>> getMembers() async {
    await Future.delayed(const Duration(seconds: 5));
    return [
      Member(
        name: 'Varun Nair',
        age: '76',
        gender: 'Male',
        relation: 'Father',
        mobileNo: '+91xxxxxxxx04',
        address: 'New delhi, India',
        hasCareSub: true,
      ),
      Member(
        name: 'Sheena Nair',
        age: '74',
        gender: 'Female',
        relation: 'Mother',
        mobileNo: '+91xxxxxxxx05',
        address: 'New delhi, India',
        hasCareSub: true,
      ),
      Member(
        name: 'Arun Nair',
        age: '43',
        gender: 'Male',
        relation: 'Self',
        mobileNo: '+91xxxxxxxx06',
        address: 'New delhi, India',
        hasCareSub: false,
      ),
    ];
  }

  @override
  Future<void> addMember(Member member) async {
    try {} catch (error) {
      throw UnimplementedError('Error: $error');
    }
  }

  @override
  Future<void> editMember(Member member) async {
    try {} catch (error) {
      throw UnimplementedError('Error: $error');
    }
  }
}
